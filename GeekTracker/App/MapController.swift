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

class MapController: UIViewController, GMSMapViewDelegate {
    let coordinate = CLLocationCoordinate2D(latitude: 52.287521, longitude: 104.287223)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.mapType = .hybrid
        mapView.delegate = self
        self.view.addSubview(mapView)
        //mapView.settings.myLocationButton = true
    }

}
