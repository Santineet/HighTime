//
//  LevelsModel.swift
//  HighTime
//
//  Created by Mairambek on 26/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//


import UIKit
import ObjectMapper

class LevelsModel: NSObject, Mappable {
    
    var id = Int()
    var slug: String = ""
    var name: String = ""
    var hasCertificate = Bool()
    var image: String = ""
    var price: Float = 0
    var currency: String = ""
    var currencySymbol: String = ""
    var duration: String = ""
    var content: String = ""
    var isPurchased: Bool? = nil

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        slug <- map["slug"]
        name <- map["name"]
        hasCertificate  <- map["has_certificate"]
        image <- map["thumbnail"]
        price <- map["price"]
        currency <- map["currency"]
        currencySymbol <- map["currency_symbol"]
        duration <- map["duration"]
        content <- map["content"]
    }
    
    
    
}
