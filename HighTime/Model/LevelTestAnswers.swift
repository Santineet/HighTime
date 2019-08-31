//
//  LevelTestAnswers.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper
import MBRadioButton

class LevelTestAnswers: NSObject, Mappable {
    
    var id = Int()
    var name: String = ""
    var correct = Bool()
    var final = Bool()
    var file = Bool()
    var thumbnail: String = ""
    var testId = Int()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        correct <- map["correct"]
        final <- map["final"]
        file <- map["file"]
        thumbnail <- map["thumbnail"]
        testId <- map["test_id"]
    }
    
    
}

