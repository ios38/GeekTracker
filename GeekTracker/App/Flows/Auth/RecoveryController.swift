//
//  RecoveryPasswordViewController.swift
//  Lesson_3_Coordinator
//
//  Created by Maksim Romanov on 11.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

final class RecoveryController: UIViewController {
    
    @IBOutlet weak var loginView: UITextField!
    
    @IBAction func recovery(_ sender: Any) {

    }
    
    private func showPassword() {
        let alert = UIAlertController(title: "Пароль", message: "123", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
