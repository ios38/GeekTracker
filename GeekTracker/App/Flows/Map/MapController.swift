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

class MapController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    //var mapView: GMSMapView?
    var mapView = MapView()
    //let coordinate = CLLocationCoordinate2D(latitude: 52.287521, longitude: 104.287223)
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var track = List<RealmLocation>()
    
    var onLogout: (() -> Void)?
    var onTracks: (() -> Void)?

    override func loadView() {
        super.loadView()
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //configureMap()
        //addStartTrackingButton()
        addSavedTracksButton()
        addlogoutButton()
        mapView.googleMapView?.delegate = self
        mapView.startButton.addTarget(self, action: #selector(startTrackButtonAction), for: .touchUpInside)
        mapView.stopButton.addTarget(self, action: #selector(stopTrackButtonAction), for: .touchUpInside)
    }
    /*
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.mapType = .hybrid
        mapView.delegate = self
        self.mapView = mapView
        self.view.addSubview(self.mapView!)
        //mapView.settings.myLocationButton = true
    }*/
    
    func addlogoutButton() {
        let button = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonAction))
        navigationItem.leftBarButtonItem = button
    }

    func addSavedTracksButton() {
        let button = UIBarButtonItem(title: "Saved Tracks", style: .plain, target: self, action: #selector(savedTracksButtonAction))
        navigationItem.rightBarButtonItem = button
    }
    /*
    func addStartTrackingButton() {
        let button = UIBarButtonItem(title: "Start tracking", style: .plain, target: self, action: #selector(startTrackButtonAction))
        navigationItem.leftBarButtonItem = button
    }

    func addStopTrackingButton() {
        let button = UIBarButtonItem(title: "Stop tracking", style: .plain, target: self, action: #selector(stopTrackButtonAction))
        navigationItem.leftBarButtonItem = button
    }*/

    @objc func logoutButtonAction() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }

    @objc func savedTracksButtonAction() {
        LocationService.shared.stopTracking()
        mapView.startButton.isHidden = false
        mapView.stopButton.isHidden = true

        NotificationCenter.default.removeObserver(self)
        //addStartTrackingButton()

        //let tracksController = TracksController()
        //tracksController.delegate = self
        //tracksController.navigationItem.title = "Saved Tracks"
        //self.navigationController?.pushViewController(tracksController, animated: true)
        
        onTracks?()
    }

    @objc func startTrackButtonAction() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.strokeColor = .yellow
        route?.strokeWidth = 3
        //route?.map = mapView
        route?.map = mapView.googleMapView

        track = List<RealmLocation>()

        LocationService.shared.startTracking()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation(_:)), name: Notification.Name("LocationServiceDidUpdateCurrentLocation"), object: nil)
        //addStopTrackingButton()
        mapView.startButton.isHidden = true
        mapView.stopButton.isHidden = false
    }
    
    @objc func stopTrackButtonAction() {
        LocationService.shared.stopTracking()
        NotificationCenter.default.removeObserver(self)
        
        let realmTrack = RealmTrack()
        realmTrack.date = "\(Date())"
        realmTrack.track = track
        try? RealmService.save(realmTrack)
        
        //addStartTrackingButton()
        mapView.startButton.isHidden = false
        mapView.stopButton.isHidden = true
    }

    @objc func didUpdateLocation(_ notification: NSNotification) {
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        let cameraPosition = GMSCameraPosition(target: location.coordinate, zoom: 15)
        //self.mapView!.animate(to: cameraPosition)
        self.mapView.googleMapView?.animate(to: cameraPosition)

        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let realmLocation = RealmLocation()
        realmLocation.latitude = Double(location.coordinate.latitude)
        realmLocation.longitude = Double(location.coordinate.longitude)
        track.append(realmLocation)
    }
    
    func showTrack(_ track: RealmTrack) {
        //print("Selected track \(track)")
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.strokeColor = .yellow
        route?.strokeWidth = 3
        //route?.map = mapView
        route?.map = mapView.googleMapView
        
        track.track.forEach { realmLocation in
            //print(realmLocation.coordinate)
            let cameraPosition = GMSCameraPosition(target: realmLocation.coordinate, zoom: 15)
            //self.mapView!.animate(to: cameraPosition)
            self.mapView.googleMapView?.animate(to: cameraPosition)
            
            routePath?.add(realmLocation.coordinate)
            route?.path = routePath
        }
    }

}

// MARK: - TracksControllerDelegate
/*
extension MapController: TracksControllerDelegate {
    func tracksControllerDidSelectTrack(_ selectedTrack: RealmTrack) {
        //print("selectedTrack: \(selectedTrack.date)")
        showTrack(selectedTrack)

    }
}*/
