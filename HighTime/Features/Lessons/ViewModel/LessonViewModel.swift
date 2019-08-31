//
//  LessonViewModel.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class LessonViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let lessonBehaviorRelay = BehaviorRelay<VideoTutorialByLessonIdModel>(value: VideoTutorialByLessonIdModel())
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = LessonRepository()
    
    func getLessonInfo(lessonId: Int, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getLessonTutorial(lessonId: lessonId).subscribe(onNext: { (lesson) in
                self.lessonBehaviorRelay.accept(lesson)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Нет соединения"))
        }
    }
    
    func isConnnected() -> Bool{
        do {
            try reachability = Reachability.init()
            
            if (self.reachability?.connection) == .wifi || (self.reachability?.connection) == .cellular {
                return true
            } else if self.reachability?.connection == .unavailable {
                return false
            } else if self.reachability?.connection == .none {
                return false
            } else {
                return false
            }
        }catch{
            return false
        }
    }
    
    
}
