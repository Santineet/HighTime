//
//  VideoTutorialByLessonIdModel.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class VideoTutorialByLessonIdModel: NSObject, Mappable {
    
    var id = Int()
    var slug: String = ""
    var name: String = ""
    var levelId: String = ""
    var videos = [VideosModel]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        slug <- map["slug"]
        name <- map["name"]
        levelId <- map["level_id"]
        videos <- map["videos"]

    }
    
    
}

