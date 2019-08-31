//
//  PassTestModel.swift
//  HighTime
//
//  Created by Mairambek on 21/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper
import MBRadioButton

class PassTestModel: NSObject, Mappable {
    

    var title: String = ""
    var content: String = ""
    var answers = [Answers]()
    var selected: Int = 0
    var isCorrect: Bool? = nil
    
    required convenience init?(map: Map) {
        self.init() 
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        content <- map["content"]
        answers <- map["answers"]
    }
    

}

