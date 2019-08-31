//
//  LessonInfoByLevelId.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class LessonInfoByLevelId: NSObject, Mappable {
    
    var id = Int()
    var slug: String = ""
    var name: String = ""
    var descriptionLesson: String = ""
    var shortDescription: String = ""
    var trial = Bool()
    var active = Bool()
    var levelId: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        slug <- map["slug"]
        name <- map["name"]
       descriptionLesson <- map["description"]
    shortDescription <- map["short_description"]
       trial <- map["trial"]
        active <- map["avtive"]
        levelId <- map["level_id"]
    }
    
    
    
}
