//
//  UserDispleyedModel.swift
//  Task
//
//  Created by Artashes Nok Nok on 3/20/21.
//

import Foundation

struct UserDispleyedModel: Codable {
    var fullName: String?
    var addres: String?
    var phoneNumber: String?
    var email:String?
    var gender:String?
    var avatar: String?
    var age : Int!
    
}

struct UsersListDispleyedModel: Codable {
    var ageRange: String?
    var users:[UserDispleyedModel]?
    
}
