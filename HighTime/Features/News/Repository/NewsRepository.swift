//
//  NewsRepository.swift
//  HighTime
//
//  Created by Mairambek on 19/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class NewsRepository: NSObject {
    
    //    MARK:    Function to retrieve News information from databse.
    //    MARK:    Функция для получения информации о Новостях из базы данных.

    func getNews() -> Observable<[NewsModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getNews(completion: { (response, error) in
               
                guard let jsonArray = response as? [[String:Any]] else { return }
                var allNews = [NewsModel]()
                for i in 0..<jsonArray.count{
                    guard let news = Mapper<NewsModel>().map(JSON: jsonArray[i]) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                
                    allNews.append(news)
                
                    if allNews.count == jsonArray.count {
                        observer.onNext(allNews)
                        observer.onCompleted()
                    }
                }
                
            })
            return Disposables.create()
        })
        
    }

}
