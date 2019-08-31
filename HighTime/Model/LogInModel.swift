//
//  LogInModel.swift
//  HighTime
//
//  Created by Mairambek on 15/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

struct LogInModel: Mappable {

    var user_token: String?
    var user_name: String?
    var user_email: String?
    
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        user_token <- map["user_token"]
        user_name <- map["fullName"]
        user_email <- map["email"]

    }
}
