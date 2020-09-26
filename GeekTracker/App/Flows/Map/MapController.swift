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
    var marker: GMSMarker?
    var markerImage: UIImage?
    
    var onLogout: (() -> Void)?
    var onTracks: (() -> Void)?
    
    let locationService = LocationService.shared
    let dateFormatter = DateFormatter()
    
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
        mapView.pickImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
    }
    
    func configureLocationService() {
        locationService
            .location
            .asObservable()
            .bind { [weak self] location in
                //print("\(location?.coordinate)")
                
                guard let location = location else { return }

                //CATransaction.begin()
                //CATransaction.setAnimationDuration(1.0)
                self?.marker?.position = location.coordinate
                //CATransaction.commit()

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
        
        self.addMarker()
    }
    
    @objc func stopTrackButtonAction() {
        LocationService.shared.stopTracking()
        NotificationCenter.default.removeObserver(self)
        
        let realmTrack = RealmTrack()
        realmTrack.date = "\(dateFormatter.string(from: Date()))"
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
    
    func addMarker(){
        let marker = GMSMarker()
        //let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //view.backgroundColor = .blue
        //marker.iconView = view
        let view = MarkerView()
        view.imageView.image = markerImage
        marker.iconView = view
        //marker.icon = GMSMarker.markerImage(with: .blue)
        //marker.icon = markerImage
        //marker.title = "\(marker.position.latitude)"
        //marker.snippet = "\(marker.position.longitude)"
        marker.map = mapView.googleMapView
        self.marker = marker
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    @objc func pickImage(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        
        present(pickerController, animated: true)
    }


}

extension MapController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image  = extractImage(info: info) {
            mapView.imageView.image = image
            self.markerImage = image
        }
        
        picker.dismiss(animated: true)
    }
    
    private func extractImage(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
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
