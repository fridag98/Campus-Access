//
//  UserModel.swift
//  CampusAccess
//
//  Created by Iñaki Janeiro Olague on 12/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var firstName : String!
    var lastName : String!
    var email : String!
    var isVisitor : Bool!
    var profilePictue: UIImage?
    var uid : String!
    
    static func getCollection(fromEmail email : String) -> String {
        if (email.contains("@tec.mx") || email.contains("@itesm.mx")) {
            return "colaboradores"
        }
        return "visitantes"
    }
    
    static func isUserVisitor(fromEmail email : String) -> Bool {
        if (email.contains("@tec.mx") || email.contains("@itesm.mx")) {
            return false
        }
        return true
    }
}
