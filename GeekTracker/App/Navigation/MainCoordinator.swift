//
//  MainCoordinator.swift
//  Lesson_3_Coordinator
//
//  Created by Maksim Romanov on 11.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMapModule()
    }
    
    private func showMapModule() {
        let controller = MapController()
        
        controller.onTracks = { [weak self] in
            self?.showTracksModule()
        }
        
        controller.onLogout = { [weak self] in
            self?.onFinishFlow?()
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        //rootController.navigationBar.isTranslucent = false
        self.rootController = rootController

    }
    
    private func showTracksModule() {
        let controller = TracksController()
        
        controller.didSelectTrack = { [weak self] in
            guard let track = controller.selectedTrack else { return }
            self?.showSelectedTrack(track)
            self?.rootController?.popViewController(animated: true)
        }
        rootController?.pushViewController(controller, animated: true)
    }
    
    private func showSelectedTrack(_ track: RealmTrack) {
        for controller in rootController!.viewControllers {
            if controller is MapController {
                let controller = controller as! MapController
                controller.showTrack(track)
            }
        }
    }

}
