//
//  RealmUser.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 09.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation

import RealmSwift

class RealmUser: Object {
    
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }

}
