//
//  LoginUserModel.swift
//  HighTime
//
//  Created by Mairambek on 01/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginUserModel: NSObject, Mappable {
    
    var name: String = ""
    var email: String = ""
    var id: Int = 0
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["fullName"]
        email <- map["email"]
        id <- map["id"]
    }
}
