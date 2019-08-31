//
//  LevelIsOpen.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class LevelIsOpenModel: NSObject, Mappable {
    
    
    var isOpen = Bool()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        isOpen <- map["is_buyed"]
    }
}
