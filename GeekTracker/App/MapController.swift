//
//  MapController.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 01.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    var mapView: GMSMapView?
    let coordinate = CLLocationCoordinate2D(latitude: 52.287521, longitude: 104.287223)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        addStartTrackingButton()
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.mapType = .hybrid
        mapView.delegate = self
        self.mapView = mapView
        self.view.addSubview(self.mapView!)
        //mapView.settings.myLocationButton = true
    }
    
    func addStartTrackingButton() {
        let button = UIBarButtonItem(title: "Start tracking", style: .plain, target: self, action: #selector(startTrackButtonAction))
        navigationItem.leftBarButtonItem = button
    }

    func addStopTrackingButton() {
        let button = UIBarButtonItem(title: "Stop tracking", style: .plain, target: self, action: #selector(stopTrackButtonAction))
        navigationItem.leftBarButtonItem = button
    }

    @objc func startTrackButtonAction() {
        LocationService.shared.startTracking()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation(_:)), name: Notification.Name("LocationServiceDidUpdateCurrentLocation"), object: nil)
        mapView?.clear()
        addStopTrackingButton()
    }
    
    @objc func stopTrackButtonAction() {
        LocationService.shared.stopTracking()
        NotificationCenter.default.removeObserver(self)
        addStartTrackingButton()
    }

    @objc func didUpdateLocation(_ notification: NSNotification) {
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        let cameraPosition = GMSCameraPosition(target: location.coordinate, zoom: 17)
        self.mapView!.animate(to: cameraPosition)
        
        let marker = GMSMarker(position: location.coordinate)
        marker.map = mapView
    }
}
