//
//  ProfileViewModel.swift
//  HighTime
//
//  Created by Mairambek on 30/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let myLevelsBehaviorRelay = BehaviorRelay<[LevelsModel]>(value: [])
    let userInfoBehaviorRelay = BehaviorRelay<UserInfoModel>(value: UserInfoModel())
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = ProfileRepository()
    
    func getLevels(completion: @escaping (Error?) -> ()) {
        if isConnnected() == true {
            self.repository.getMyLevels().subscribe(onNext: { (levelsInfo) in
                self.myLevelsBehaviorRelay.accept(levelsInfo)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Нет соединения"))
        }
    }
    
    func getUserInfo(completion: @escaping (Error?) -> ()) {
        if isConnnected() == true {
            self.repository.getUserInfo().subscribe(onNext: { (userInfo) in
                self.userInfoBehaviorRelay.accept(userInfo)
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
