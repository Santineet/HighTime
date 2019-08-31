//
//  LevelInfoRepository.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class LevelInfoRepository: NSObject {
    
    //    MARK:    Function to retrieve Levels information from databse.
    //    MARK:    Функция для получения информации о уровнях из базы данных.
    func getLessonInfo(levelId: Int) -> Observable<[LessonInfoByLevelId]> {
        return Observable.create({ (observer) -> Disposable in
            let param = ["id": levelId]
            ServiceManager.sharedInstance.getLessonsInfoByLevelId(param: param, completion: { (response, error) in
                guard let jsonArray = response as? [[String:Any]] else { return }
                var lessonsInfo = [LessonInfoByLevelId]()
                for i in 0..<jsonArray.count{
                    guard let lessonInfo = Mapper<LessonInfoByLevelId>().map(JSON: jsonArray[i]) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                    lessonsInfo.append(lessonInfo)
                    if lessonsInfo.count == jsonArray.count {
                        observer.onNext(lessonsInfo)
                        observer.onCompleted()
                    }
                }
            })
            return Disposables.create()
        })
    }
    
    
    
    func getLevelIsOpen(levelId: Int) -> Observable<LevelIsOpenModel> {
        return Observable.create({ (observer) -> Disposable in
            let param = ["id": levelId]
            ServiceManager.sharedInstance.getLevelIsOpen(param: param, completion: { (response, error) in
                guard let jsonArray = response as? [String:Any] else { return }
                
                guard let isOpen = Mapper<LevelIsOpenModel>().map(JSON: jsonArray) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                observer.onNext(isOpen)
                        observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    
    func paymentWithPromocode(levelId: Int,promocode: String)-> Observable<PaymentWithPromocode>{
        return Observable.create({ (observer) -> Disposable in
          
            ServiceManager.sharedInstance.paymentWithPromocode(levelId: levelId, promocode: promocode, completion: { (response, error) in
                
                guard let jsonArray = response as? [String:Any] else {
                    print("JSON REturn")
                    return
                }

                guard let success = Mapper<PaymentWithPromocode>().map(JSON: jsonArray) else {
        
                    print("erroesuccess")
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                print("success23232 \(success.result)")
                observer.onNext(success)
                observer.onCompleted()
            })
            return Disposables.create()
        })

        
    }
    
    
    
    
    
    
}
