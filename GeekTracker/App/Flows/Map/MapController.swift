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
import RxCocoa

class MapController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    var mapView = MapView()
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var track = List<RealmLocation>()
    
    var onLogout: (() -> Void)?
    var onTracks: (() -> Void)?
    
    let locationService = LocationService.shared

    override func loadView() {
        super.loadView()
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationService()
        addSavedTracksButton()
        addlogoutButton()
        
        mapView.googleMapView?.delegate = self
        mapView.startButton.addTarget(self, action: #selector(startTrackButtonAction), for: .touchUpInside)
        mapView.stopButton.addTarget(self, action: #selector(stopTrackButtonAction), for: .touchUpInside)
    }
    
    func configureLocationService() {
        locationService
            .location
            .asObservable()
            .bind { [weak self] location in
                //print("\(location?.coordinate)")
                
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                // Обновляем путь у линии маршрута путём повторного присвоения
                self?.route?.path = self?.routePath
                
                // Чтобы наблюдать за движением, установим камеру на только что добавленную точку
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
                self?.mapView.googleMapView?.animate(to: position)
                
                let realmLocation = RealmLocation()
                realmLocation.latitude = Double(location.coordinate.latitude)
                realmLocation.longitude = Double(location.coordinate.longitude)
                self?.track.append(realmLocation)

        }
    }
    
    func addlogoutButton() {
        let button = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonAction))
        navigationItem.leftBarButtonItem = button
    }

    func addSavedTracksButton() {
        let button = UIBarButtonItem(title: "Saved Tracks", style: .plain, target: self, action: #selector(savedTracksButtonAction))
        navigationItem.rightBarButtonItem = button
    }

    @objc func logoutButtonAction() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }

    @objc func savedTracksButtonAction() {
        LocationService.shared.stopTracking()
        NotificationCenter.default.removeObserver(self)

        mapView.startButton.isHidden = false
        mapView.stopButton.isHidden = true

        NotificationCenter.default.removeObserver(self)

        onTracks?()
    }

    @objc func startTrackButtonAction() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.strokeColor = .yellow
        route?.strokeWidth = 3
        route?.map = mapView.googleMapView

        track = List<RealmLocation>()

        LocationService.shared.startTracking()
        //NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation(_:)), name: Notification.Name("LocationServiceDidUpdateCurrentLocation"), object: nil)
        
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
        
        mapView.startButton.isHidden = false
        mapView.stopButton.isHidden = true
    }
    /*
    @objc func didUpdateLocation(_ notification: NSNotification) {
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        let cameraPosition = GMSCameraPosition(target: location.coordinate, zoom: 15)
        self.mapView.googleMapView?.animate(to: cameraPosition)

        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let realmLocation = RealmLocation()
        realmLocation.latitude = Double(location.coordinate.latitude)
        realmLocation.longitude = Double(location.coordinate.longitude)
        track.append(realmLocation)
    }*/
    
    func showTrack(_ track: RealmTrack) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.strokeColor = .yellow
        route?.strokeWidth = 3
        route?.map = mapView.googleMapView
        
        track.track.forEach { realmLocation in
            //print(realmLocation.coordinate)
            let cameraPosition = GMSCameraPosition(target: realmLocation.coordinate, zoom: 15)
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
