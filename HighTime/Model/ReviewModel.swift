//
//  ReviewModel.swift
//  HighTime
//
//  Created by Mairambek on 19/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class ReviewModel: NSObject, Mappable {
    
    var id = Int()
    var name: String = ""
    var comment: String = ""
    var date: String = ""
    var time: String = ""
    var image: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
       
        id <- map["id"]
        name <- map["name"]
        comment <- map["comment"]
        date <- map["date"]
        time <- map["time"]
        image <- map["thumbnail"]
        
    }
    
}
