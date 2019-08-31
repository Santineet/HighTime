//
//  NewsModel.swift
//  HighTime
//
//  Created by Mairambek on 17/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class NewsModel: NSObject, Mappable {
   
   
    var id = Int()
    var titleNew: String = ""
    var messageNews: String = ""
    var contentNews: String = ""
    
    var status = Bool()
   
    var titleNew_kg: String = ""
    var messageNews_kg: String = ""
    var contentNews_kg: String = ""

    var titleNew_en: String = ""
    var messageNews_en: String = ""
    var contentNews_en: String = ""

    var imageSmall: String = ""
    var imageLarge: String = ""
    
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        titleNew <- map["name"]
        messageNews <- map["short"]
        contentNews <- map["content"]
        
        titleNew_kg <- map["name_kg"]
        messageNews_kg <- map["short_kg"]
        contentNews_kg <- map["content_kg"]
        
        titleNew_en <- map["name_en"]
        messageNews_en <- map["short_en"]
        contentNews_en <- map["content_en"]
        
        imageSmall <- map["thumbmailS"]
        imageLarge <- map["thumbmailL"]
        
        status <- map["status"]
    }
    
    
    
}
