//
//  UserInfoModel.swift
//  HighTime
//
//  Created by Mairambek on 02/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class UserInfoModel: NSObject, Mappable {
    var name: String = ""
    var balance: String = ""
    var accountNumber: String = ""
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        name <- map["fullName"]
         balance <- map["balance"]
         accountNumber <- map["account_number"]
    }
    
}
