//
//  RealmTrack.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 04.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import CoreLocation
import RealmSwift

class RealmLocation: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}

class RealmTrack: Object {
    
    @objc dynamic var date = ""
    var track = List<RealmLocation>()
    
    override static func primaryKey() -> String? {
        return "date"
    }

}
