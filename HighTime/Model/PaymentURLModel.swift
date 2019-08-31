//
//  PaymentURLModel.swift
//  HighTime
//
//  Created by Mairambek on 29/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentURLModel: NSObject, Mappable {
    
    var url: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        url <- map["payment_link"]
    }
    
    
}

