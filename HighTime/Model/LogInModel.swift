//
//  LogInModel.swift
//  HighTime
//
//  Created by Mairambek on 15/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class LogInModel: NSObject, Mappable {
    
    var result = LoginSuccess()
    var user = LoginUserModel()
    var message: String = ""
    var error: String = ""
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        result <- map["result"]
        user <- map["user"]
        message <- map["message"]
        error <- map["error"]
    }
    
}
