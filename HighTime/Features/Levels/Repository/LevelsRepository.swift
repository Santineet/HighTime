//
//  LevelsRepository.swift
//  HighTime
//
//  Created by Mairambek on 26/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class LevelsRepository: NSObject {
    
    //    MARK:    Function to retrieve Levels information from databse.
    //    MARK:    Функция для получения информации о уровнях из базы данных.
    func getLevels() -> Observable<[LevelsModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getLevels(completion: { (response, error) in
                guard let jsonArray = response as? [[String:Any]] else { return }
                var levelsInfo = [LevelsModel]()
                for i in 0..<jsonArray.count{
                    guard let levelInfo = Mapper<LevelsModel>().map(JSON: jsonArray[i]) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                    levelsInfo.append(levelInfo)
                    if levelsInfo.count == jsonArray.count {
                        observer.onNext(levelsInfo)
                        observer.onCompleted()
                    }
                }
            })
            return Disposables.create()
        })
        
    }
    
    func getLevelsIsOpen() -> Observable<[LevelsModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getLevelsIsOpenForProfile(completion: { (response, error) in
                guard let jsonArray = response as? [[String:Any]] else { return }
                var isOpenLevels = [LevelsModel]()
                for i in 0..<jsonArray.count{
                guard let isOpenLevel = Mapper<LevelsModel>().map(JSON: jsonArray[i]) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                    }
                    isOpenLevels.append(isOpenLevel)
                    
                    if isOpenLevels.count == jsonArray.count {
                        observer.onNext(isOpenLevels)
                        observer.onCompleted()
                    }
                }
            })
            return Disposables.create()
            
        })
        
        
    }
    
    
    
}
