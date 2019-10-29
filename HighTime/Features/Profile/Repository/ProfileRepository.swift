//
//  ProfileRepository.swift
//  HighTime
//
//  Created by Mairambek on 30/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class ProfileRepository: NSObject {
    
    func getMyLevels() -> Observable<[LevelsModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getLevelsIsOpenForProfile(completion: { (response, error) in
                
                if error != nil {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    
                } else {
                    guard let jsonArray = response as? [[String:Any]] else { return }
                    var levelsInfo = [LevelsModel]()
                    for i in 0..<jsonArray.count{
                        guard let levelInfo = Mapper<LevelsModel>().map(JSON: jsonArray[i]) else {
                            return
                        }
                        levelsInfo.append(levelInfo)
                        if levelsInfo.count == jsonArray.count {
                            observer.onNext(levelsInfo)
                            observer.onCompleted()
                        }
                    }
                }
            })
            return Disposables.create()
            
        })
    }

    
    func getUserInfo() -> Observable<UserInfoModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getUserInfo(completion: { (response, error) in
                if error != nil {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                } else {
                    guard let jsonArray = response as? [String:Any] else { return }
                    guard let userInfo = Mapper<UserInfoModel>().map(JSON: jsonArray) else {
                        return
                    }
                    observer.onNext(userInfo)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
        })
    }
    
}

