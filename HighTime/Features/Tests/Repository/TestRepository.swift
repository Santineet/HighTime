//
//  TestRepository.swift
//  HighTime
//
//  Created by Mairambek on 22/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class TestRepository: NSObject {
    
    //    MARK:    Function to retrieve Tests information from databse.
    //    MARK:    Функция для получения информации Отзывов из базы данных.
    func getTests() -> Observable<[PassTestModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getTest(completion: { (response, error) in
                guard let jsonArray = response as? [[String:Any]] else { return }
                var questions = [PassTestModel]()
                for i in 0..<jsonArray.count{
                    guard let question = Mapper<PassTestModel>().map(JSON: jsonArray[i]) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                    questions.append(question)
                    if questions.count == jsonArray.count {
                        observer.onNext(questions)
                        observer.onCompleted()
                    }
                }
            })
            return Disposables.create()
        })
    }
    
    
}


