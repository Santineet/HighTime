//
//  LoginSuccess.swift
//  HighTime
//
//  Created by Mairambek on 15/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

struct LoginSuccess: Mappable {
    
    var success: LogInModel?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        success <- map["success"]
    }
}
