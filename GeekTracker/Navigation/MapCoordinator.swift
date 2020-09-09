//
//  MapCoordinator.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 09.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
//import RealmSwift

class MapCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var mapController: MapController?
    private var tracksCoordinator: TracksCoordinator?

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let mapController = MapController()
        mapController.delegate = self
        presenter.pushViewController(mapController, animated: true)
        self.mapController = mapController
    }
    
//    func viewTrack(_ track: RealmTrack) {
//        mapController?.viewTrack(track)
//    }

}

// MARK: - TracksControllerDelegate

extension MapCoordinator: MapControllerDelegate {
    func toSavedTracks() {
        let tracksCoordinator = TracksCoordinator(presenter: presenter)
        tracksCoordinator.delegate = self
        tracksCoordinator.start()
        self.tracksCoordinator = tracksCoordinator
  }
}

// MARK: - TracksControllerDelegate

extension MapCoordinator: TracksCoordinatorDelegate {
    func viewTrack(_ track: RealmTrack) {
        mapController?.viewTrack(track)
  }
}
