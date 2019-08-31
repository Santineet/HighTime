//
//  PaymentWithPromocode.swift
//  HighTime
//
//  Created by Mairambek on 28/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentWithPromocode: NSObject, Mappable {
   
    var result: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
      result <- map["Result"]
    }
    
    
}

