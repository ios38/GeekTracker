//
//  MapView.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 12.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit

class MapView: UIView {
    var googleMapView: GMSMapView?
    let coordinate = CLLocationCoordinate2D(latitude: 52.287521, longitude: 104.287223)

    var imageView = UIImageView()
    var pickImageButton = UIButton(type: .system)

    var startButton = UIButton(type: .system)
    var stopButton = UIButton(type: .system)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureSubviews() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12)
        googleMapView = GMSMapView.map(withFrame: self.frame, camera: camera)
        googleMapView?.mapType = .hybrid
        googleMapView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.googleMapView!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        pickImageButton.translatesAutoresizingMaskIntoConstraints = false
        pickImageButton.setTitle("Pick Image", for: .normal)
        pickImageButton.setTitleColor(.white, for: .normal)
        pickImageButton.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 0.9)
        pickImageButton.layer.cornerRadius = 15.0
        pickImageButton.accessibilityIdentifier = "Pick Image"
        self.addSubview(pickImageButton)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start Track", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        //startButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        startButton.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 0.9)
        startButton.layer.cornerRadius = 15.0
        startButton.accessibilityIdentifier = "startButton"
        self.addSubview(startButton)

        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.setTitle("Stop Track", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        //stopButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        stopButton.backgroundColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: 0.9)
        stopButton.layer.cornerRadius = 15.0
        stopButton.accessibilityIdentifier = "stopButton"
        stopButton.isHidden = true
        self.addSubview(stopButton)

    }
    
    func setupConstraints() {
        googleMapView?.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(15)
        }

        startButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(15)
        }
        
        stopButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(15)
        }
        
        pickImageButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }

    }
}
