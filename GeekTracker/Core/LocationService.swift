//
//  LocationService.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 02.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    private var locationManager = CLLocationManager()
    private var updateLocationBlock: () -> () = { }
    private var updateLocationCount = 0
    private let fakeUpdateLocationCount = 2
    
    //let location: Variable<CLLocation?> = Variable(nil)
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            let alert = UIAlertController(title: "Location access not allowed", message: "Please allow access in Privacy Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController?.present(alert, animated: true, completion: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocationBlock()
        @unknown default:
            return
        }
        /*
        _ = location.subscribe { (event) in
            print(self.location.value?.coordinate)
        }*/
    }
    
    func stopTracking() {
        self.locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            updateLocationBlock()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateLocationCount >= fakeUpdateLocationCount {
            guard let location = locations.first else { return }
            //print("\(location.coordinate)")
            let locationDict:[String: CLLocation] = ["location": location]
            NotificationCenter.default.post(name: NSNotification.Name("LocationServiceDidUpdateCurrentLocation"), object: nil, userInfo: locationDict)
            
            self.location.accept(locations.last)
        } else {
            updateLocationCount += 1
        }
    }

}
