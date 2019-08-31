//
//  ReviewRepository.swift
//  HighTime
//
//  Created by Mairambek on 19/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class ReviewRepository: NSObject {
    
    //    MARK:    Function to retrieve Review information from databse.
    //    MARK:    Функция для получения информации Отзывов из базы данных.
    
    func getReview() -> Observable<[ReviewModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getReviewList(completion: { (response, error) in
                guard let jsonArray = response as? [[String:Any]] else { return }
                var allReview = [ReviewModel]()
                for i in 0..<jsonArray.count{
                    guard let review = Mapper<ReviewModel>().map(JSON: jsonArray[i]) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                    allReview.append(review)
                    if allReview.count == jsonArray.count {
                        observer.onNext(allReview)
                        observer.onCompleted()
                    }
                }
            })
            return Disposables.create()
        })
    }
    
    
}
