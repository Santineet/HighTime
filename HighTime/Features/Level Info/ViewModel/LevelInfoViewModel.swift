//
//  LevelInfoViewModel.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LevelInfoViewModel: NSObject {
    
    var reachability:Reachability?
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let lessonsBehaviorRelay = BehaviorRelay<[LessonInfoByLevelId]>(value: [])
    let isOpenBehaviorRelay = BehaviorRelay<LevelIsOpenModel>(value: LevelIsOpenModel())
    let promocodeBehaviorRelay = BehaviorRelay<PaymentWithPromocode>(value: PaymentWithPromocode())
    
    private let disposeBag = DisposeBag()
    private let repository = LevelInfoRepository()
    
    func getLessonsByLevelId(levelId: Int, completion: @escaping (Error?) -> ()) {
        if isConnnected() == true {
        self.repository.getLessonInfo(levelId: levelId).subscribe(onNext: { (lessonsInfo) in
            self.lessonsBehaviorRelay.accept(lessonsInfo)
        }, onError: { (error) in
            self.errorBehaviorRelay.accept(error)
        }).disposed(by: disposeBag)
            
        } else {
            completion(NSError.init(message: "Нет соединения"))
        }
    }
    
    
    func getLevelIsOpen(levelId: Int){
        
        self.repository.getLevelIsOpen(levelId: levelId).subscribe(onNext: { (isOpen) in
            self.isOpenBehaviorRelay.accept(isOpen)
        }, onError: { (error) in
            self.errorBehaviorRelay.accept(error)
        }).disposed(by: disposeBag)
        
    }
    
    func paymentWithPromocode(levelId: Int,promocode: String, completion: @escaping (Error?) -> ()) {
        if isConnnected() == true {
            self.repository.paymentWithPromocode(levelId: levelId, promocode: promocode).subscribe(onNext: { (success) in
                print("success is work")
                print(success.result)
                self.promocodeBehaviorRelay.accept(success)
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
