//
//  LoginController.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 07.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift

final class LoginController: UIViewController {
    var loginView = LoginView()
    var onMap: (() -> Void)?
    let loginError = "Login/password error!"

    deinit {
        print("LoginController deinitialized")
    }

    override func loadView() {
        super.loadView()
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        loginView.loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        loginView.loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func loginButtonAction() {
        guard let login = self.loginView.loginTextField.text, login != "",
              let password = self.loginView.passwordTextField.text, password != "" else {
                //print("login/password data error")
                loginView.titleLabel.text = loginError
                return
        }
        let realmUser: Results<RealmUser> = try! RealmService.get(RealmUser.self).filter("login == %@", login)
        if realmUser.first?.password == password {
            onMap?()
        } else {
            loginView.titleLabel.text = loginError
            loginView.loginTextField.text = ""
            loginView.passwordTextField.text = ""
            loginView.loginTextField.becomeFirstResponder()
        }
    }
    
    @objc func registerButtonAction() {
        guard let login = self.loginView.loginTextField.text, login != "",
              let password = self.loginView.passwordTextField.text, password != ""
              else {
              //print("login/password data error")
              loginView.titleLabel.text = loginError
              return
        }
        let realmUser = RealmUser()
        realmUser.login = login
        realmUser.password = password
        try? RealmService.save(realmUser)
        onMap?()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        loginView.titleLabel.text = ""
    }
}
