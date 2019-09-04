//
//  LoginToken.swift
//  HighTime
//
//  Created by Mairambek on 01/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginToken: NSObject, Mappable {
    
    var token: String = ""
    var tokenRegister: String = ""
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        token <- map["user_token"]
        tokenRegister <- map["token"]
    }
}
