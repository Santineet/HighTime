//
//  levelTestsModel.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class LevelTestsModel: NSObject, Mappable {
    
    var id = Int()
    var slug: String = ""
    var name: String = ""
    var content: String = ""
    var lessonId = Int()
    var videoId = Int()
    var answer: String = ""
    var final = Bool()
    var answers = [LevelTestAnswers]()
    var isSelected: Int = 0
    var isCorrect: Bool? = nil

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        slug <- map["slug"]
        name <- map["name"]
        content <- map["content"]
        lessonId <- map["lesson_id"]
        videoId <- map["video_id"]
        answer <- map["answer"]
        final <- map["final"]
        answers <- map["answers"]
        
    }
    
    
}

