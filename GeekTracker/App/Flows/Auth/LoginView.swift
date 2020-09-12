//
//  LoginView.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 07.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
    let titleLabel = UILabel()
    let loginLabel = UILabel()
    var loginTextField = UITextField()
    let passwordLabel = UILabel()
    var passwordTextField = UITextField()
    let loginButton = UIButton()
    let registerButton = UIButton()
    let recoveryButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "GeekTracker"
        titleLabel.textColor = .lightGray
        self.addSubview(titleLabel)

        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "Login"
        loginLabel.textColor = .lightGray
        self.addSubview(loginLabel)
        
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.borderStyle = .roundedRect
        loginTextField.autocapitalizationType = .none
        loginTextField.autocorrectionType = .no
        loginTextField.textContentType = .username
        loginTextField.spellCheckingType = .no
        loginTextField.placeholder = "Login"
        loginTextField.accessibilityIdentifier = "userLoginTextField"
        self.addSubview(loginTextField)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password"
        passwordLabel.textColor = .lightGray
        self.addSubview(passwordLabel)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .password
        passwordTextField.spellCheckingType = .no
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.accessibilityIdentifier = "userPasswordTextField"
        self.addSubview(passwordTextField)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.accessibilityIdentifier = "userLoginButton"
        self.addSubview(loginButton)
        
        recoveryButton.translatesAutoresizingMaskIntoConstraints = false
        recoveryButton.setTitle("Recovery password", for: .normal)
        recoveryButton.setTitleColor(.systemBlue, for: .normal)
        self.addSubview(recoveryButton)

        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        self.addSubview(registerButton)

    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }

        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(self.loginLabel.snp.bottom).offset(20)
            //make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().inset(100)
        }

        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(self.loginTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.passwordLabel.snp.bottom).offset(20)
            //make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().inset(100)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        recoveryButton.snp.makeConstraints { make in
            make.top.equalTo(self.loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(self.recoveryButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
    }

}
