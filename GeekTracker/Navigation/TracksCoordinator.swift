//
//  TracksCoordinator.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 08.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift

protocol TracksCoordinatorDelegate: class {
  func viewTrack(_ track: RealmTrack)
}

class TracksCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var tracksController: TracksController?
    weak var delegate: TracksCoordinatorDelegate?

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let tracksController = TracksController()
        tracksController.delegate = self
        presenter.pushViewController(tracksController, animated: true)
        self.tracksController = tracksController
    }

}

// MARK: - TracksControllerDelegate

extension TracksCoordinator: TracksControllerDelegate {
    func tracksControllerDidSelectTrack(_ selectedTrack: RealmTrack) {
        //print("selectedTrack: \(selectedTrack.date)")
        presenter.popViewController(animated: true)
        delegate?.viewTrack(selectedTrack)

    }
}
