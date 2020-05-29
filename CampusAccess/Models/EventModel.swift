//
//  EventModel.swift
//  CampusAccess
//
//  Created by Rigoberto Valadez on 21/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class EventModel: NSObject, Codable {
    var name : String
    var desc : String
    var url : URL
    
    init(name : String, desc : String, url : URL) {
        self.name = name
        self.desc = desc
        self.url = url
    }
}
