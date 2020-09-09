//
//  LoginCoordinator.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 07.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

final class LoginCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        let controller = LoginController()

        controller.onMap = { [weak self] in
            self?.showMapModule()
        }
        
        /*
        controller.onRecover = { [weak self] in
            self?.showRecoverModule()
        }
        
        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }*/
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule() {
        let controller = MapController()
        rootController?.pushViewController(controller, animated: true)
    }
    
}
