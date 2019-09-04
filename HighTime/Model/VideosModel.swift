//
//  VideosModel.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class VideosModel: Mappable {
    
    var type: String = ""
    var id = Int()
    var name: String = ""
    var videoImage: String = ""
    var duration = Float()
    var lessonId = Int()
    var urlHighVideo: String = ""
    var urlLowVideo: String = ""
    var youTubeURL: String = ""
    
    var tests = [LevelTestsModel]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        id <- map["id"]
        name <- map["name"]
        videoImage <- map["thumbnail"]
        duration <- map["duration"]
        lessonId <- map["lesson_id"]
        urlHighVideo <- map["url_high"]
        urlLowVideo <- map["url_low"]
        youTubeURL <- map["url_youtube"]
        tests <- map["tests"]
    }
}
