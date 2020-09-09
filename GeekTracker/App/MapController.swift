//
//  MapController.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 01.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

protocol MapControllerDelegate: class {
  func toSavedTracks()
}

class MapController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    var mapView: GMSMapView?
    let coordinate = CLLocationCoordinate2D(latitude: 52.287521, longitude: 104.287223)
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var track = List<RealmLocation>()
    weak var delegate: MapControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        addStartTrackingButton()
        addLoadLastTrackButton()
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
    
    func addLoadLastTrackButton() {
        let button = UIBarButtonItem(title: "Saved Tracks", style: .plain, target: self, action: #selector(savedTracksButtonAction))
        navigationItem.rightBarButtonItem = button
    }

    func addStartTrackingButton() {
        let button = UIBarButtonItem(title: "Start tracking", style: .plain, target: self, action: #selector(startTrackButtonAction))
        navigationItem.leftBarButtonItem = button
    }

    func addStopTrackingButton() {
        let button = UIBarButtonItem(title: "Stop tracking", style: .plain, target: self, action: #selector(stopTrackButtonAction))
        navigationItem.leftBarButtonItem = button
    }
    
    func viewTrack(_ track: RealmTrack) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.strokeColor = .yellow
        route?.strokeWidth = 3
        route?.map = mapView

        track.track.forEach { realmLocation in
            //print(realmLocation.coordinate)
            let cameraPosition = GMSCameraPosition(target: realmLocation.coordinate, zoom: 15)
            self.mapView!.animate(to: cameraPosition)
            
            routePath?.add(realmLocation.coordinate)
            route?.path = routePath
        }
    }

    @objc func startTrackButtonAction() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.strokeColor = .yellow
        route?.strokeWidth = 3
        route?.map = mapView
        
        track = List<RealmLocation>()

        LocationService.shared.startTracking()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation(_:)), name: Notification.Name("LocationServiceDidUpdateCurrentLocation"), object: nil)
        addStopTrackingButton()
    }
    
    @objc func stopTrackButtonAction() {
        LocationService.shared.stopTracking()
        NotificationCenter.default.removeObserver(self)
        
        let realmTrack = RealmTrack()
        realmTrack.date = "\(Date())"
        realmTrack.track = track
        try? RealmService.save(item: realmTrack)
        
        addStartTrackingButton()
    }

    @objc func didUpdateLocation(_ notification: NSNotification) {
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        let cameraPosition = GMSCameraPosition(target: location.coordinate, zoom: 15)
        self.mapView!.animate(to: cameraPosition)

        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let realmLocation = RealmLocation()
        realmLocation.latitude = Double(location.coordinate.latitude)
        realmLocation.longitude = Double(location.coordinate.longitude)
        track.append(realmLocation)
    }
    
    @objc func savedTracksButtonAction() {
        LocationService.shared.stopTracking()
        NotificationCenter.default.removeObserver(self)
        addStartTrackingButton()

        //let tracksController = TracksController()
        //tracksController.navigationItem.title = "Saved Tracks"
        //self.navigationController?.pushViewController(tracksController, animated: true)
        
        delegate?.toSavedTracks()
    }
    
}
