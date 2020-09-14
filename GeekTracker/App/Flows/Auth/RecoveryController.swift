//
//  RecoveryPasswordViewController.swift
//  Lesson_3_Coordinator
//
//  Created by Maksim Romanov on 11.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift

final class RecoveryController: UIViewController {
    
    var recoveryView = RecoveryView()
    var safeView = SafeView()

    let loginError = "User not found!"

    deinit {
        print("LoginController deinitialized")
    }

    override func loadView() {
        super.loadView()
        self.view = recoveryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        recoveryView.recoveryButton.addTarget(self, action: #selector(recoveryButtonAction), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: Notification.Name("enterBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: Notification.Name("enterForeground"), object: nil)
        
        configureLoginBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func configureLoginBindings() {
        recoveryView.loginTextField.rx.text
            .map { login in
                return !(login ?? "").isEmpty
        }
            .bind { [weak recoveryView] inputFilled in
                let color: UIColor = inputFilled ? .systemBlue : .systemGray
                recoveryView?.recoveryButton.setTitleColor(color, for: .normal)
                recoveryView?.recoveryButton.isEnabled = inputFilled
        }
    }

    @objc func recoveryButtonAction() {
        //let alert = UIAlertController(title: "Пароль", message: "123", preferredStyle: .alert)
        //let ok = UIAlertAction(title: "OK", style: .cancel)
        //alert.addAction(ok)
        //present(alert, animated: true)
        
        guard let login = self.recoveryView.loginTextField.text, login != ""
              else {
              recoveryView.titleLabel.text = loginError
              return
        }
        
        let realmUser: Results<RealmUser> = try! RealmService.get(RealmUser.self).filter("login == %@", login)
        recoveryView.titleLabel.text = realmUser.count == 0 ? loginError : "Password: \(realmUser.first!.password)"
    }
    
    @objc func enterBackground() {
        self.view = safeView
    }
    
    @objc func enterForeground() {
        self.view = recoveryView
    }

}
