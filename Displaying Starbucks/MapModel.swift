//
//  MapModel.swift
//  Displaying Starbucks
//
//  Created by Saddam Al Amin on 4/26/17.
//  Copyright © 2017 Saddam Al Amin. All rights reserved.
//

import Foundation
import CoreLocation

class MapModel {
    
    var title: String?
    var address: String?
    var lat: String?
    var long: String?
    
    init(title:String, address:String , lat: String , long: String) {
        self.title = title
        self.address = address
        self.lat = lat
        self.long = long
    }
    
}
