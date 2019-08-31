//
//  LevelsViewModel.swift
//  HighTime
//
//  Created by Mairambek on 26/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LevelsViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let levelsBehaviorRelay = BehaviorRelay<[LevelsModel]>(value: [])
    var isOpenBehaviorRelay = BehaviorRelay<[LevelsModel]>(value: [])

    var reachability:Reachability?

    private let disposeBag = DisposeBag()
    private let repository = LevelsRepository()
    
    func getLevels(completion: @escaping (Error?) -> ()) {
        if isConnnected() == true {
        self.repository.getLevels().subscribe(onNext: { (levelsInfo) in
            self.levelsBehaviorRelay.accept(levelsInfo)
        }, onError: { (error) in
            self.errorBehaviorRelay.accept(error)
        }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Нет соединения"))            
        }
    }
    
    
    func getLevelIsOpen(){
        self.repository.getLevelsIsOpen().subscribe(onNext: { (isOpenLevels) in
            self.isOpenBehaviorRelay.accept(isOpenLevels)
        }, onError: { (error) in
            self.errorBehaviorRelay.accept(error)
        }).disposed(by: disposeBag)
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
