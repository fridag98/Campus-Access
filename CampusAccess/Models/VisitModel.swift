//
//  VisitModel.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 21/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class VisitModel: NSObject {
    var name : String!
    var motive : String!
    var date : Date!
    var responsable : String!
    var uid : String!
    
    init(name:String, motive:String, responsable:String, date:Date){
        self.name = name
        self.motive = motive
        self.responsable = responsable
        self.date = date
    }
}
