//
//  AuthCoordinator.swift
//  Lesson_3_Coordinator
//
//  Created by Maksim Romanov on 11.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        let controller = LoginController()
        
        controller.onRecover = { [weak self] in
            self?.showRecoverModule()
        }
        
        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showRecoverModule() {
        let controller = RecoveryController()
        rootController?.pushViewController(controller, animated: true)
    }
    
}
