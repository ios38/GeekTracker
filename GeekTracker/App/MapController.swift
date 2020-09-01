//
//  MapController.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 01.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    var mapView: GMSMapView?
    let coordinate = CLLocationCoordinate2D(latitude: 52.287521, longitude: 104.287223)
    var locationManager: CLLocationManager?
    var updateLocationBlock: () -> () = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        configureLocationManager()
        configureNavigationBar()
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
    
    func configureNavigationBar() {
        let trackButton = UIBarButtonItem(title: "Track", style: .plain, target: self, action: #selector(trackLocation))
        navigationItem.leftBarButtonItem = trackButton
    }

    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }

    @objc func trackLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        updateLocationBlock = {
            self.locationManager?.startUpdatingLocation()
        }

        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location access not allowed", message: "Please allow access in Privacy Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocationBlock()
        @unknown default:
            return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            updateLocationBlock()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newCoordinate = locations.first?.coordinate else { return }
        
        let cameraPosition = GMSCameraPosition(target: newCoordinate, zoom: 17)
        self.mapView!.animate(to: cameraPosition)
        
        let marker = GMSMarker(position: newCoordinate)
        marker.map = mapView
        
    }
    
}
