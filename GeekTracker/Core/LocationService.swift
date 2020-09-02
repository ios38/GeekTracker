//
//  LocationService.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 02.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    private var locationManager = CLLocationManager()
    private var updateLocationBlock: () -> () = { }
    private var updateLocationCount = 0
    private let fakeUpdateLocationCount = 2

    override init() {
        super.init()
        locationManager.delegate = self
        print("LocationService initialized")
    }
    
    deinit {
        print("LocationService deinitialized")
    }
    
    func startTracking() {
        let status = CLLocationManager.authorizationStatus()
        
        updateLocationBlock = {
            self.updateLocationCount = 0
            self.locationManager.startUpdatingLocation()
        }

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            //print("Location access not allowed, please allow access in Privacy Settings")
            let alert = UIAlertController(title: "Location access not allowed", message: "Please allow access in Privacy Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController?.present(alert, animated: true, completion: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            //locationManager.startUpdatingLocation()
            updateLocationBlock()
            print("LocationService started updating location")
        @unknown default:
            return
        }
        
    }
    
    func stopTracking() {
        self.locationManager.stopUpdatingLocation()
        print("LocationService stopped updating location")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            //locationManager.startUpdatingLocation()
            updateLocationBlock()
            print("LocationService started updating location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateLocationCount >= fakeUpdateLocationCount {
            guard let location = locations.first else { return }
            print("\(location.coordinate)")
            let locationDict:[String: CLLocation] = ["location": location]
            NotificationCenter.default.post(name: NSNotification.Name("LocationServiceDidUpdateCurrentLocation"), object: nil, userInfo: locationDict)
        } else {
            updateLocationCount += 1
        }
    }

}
