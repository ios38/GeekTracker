//
//  RecoveryView.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 12.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import SnapKit

class RecoveryView: UIView {
    let titleLabel = UILabel()
    let loginLabel = UILabel()
    var loginTextField = UITextField()
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
        titleLabel.text = ""
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
        
        
        recoveryButton.translatesAutoresizingMaskIntoConstraints = false
        recoveryButton.setTitle("Recovery password", for: .normal)
        recoveryButton.setTitleColor(.systemBlue, for: .normal)
        recoveryButton.accessibilityIdentifier = "recoveryButton"
        self.addSubview(recoveryButton)
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
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

        recoveryButton.snp.makeConstraints { make in
            make.top.equalTo(self.loginTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
}
