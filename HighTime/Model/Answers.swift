//
//  Answers.swift
//  HighTime
//
//  Created by Mairambek on 21/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class Answers: Mappable {
    
    var isCorrect = Bool()
    var title: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        isCorrect <- map["is_correct"]
        title <- map["title"]
    }
}
