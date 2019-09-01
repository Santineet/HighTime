//
//  LoginRepository.swift
//  HighTime
//
//  Created by Mairambek on 31/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class LoginRepository: NSObject {
    
    func registr(name: String, emailOrNumber: String, password: String) -> Observable<LogInModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.registr(name: name, emailOrNumber: emailOrNumber, password: password, completion: { (responseJSON, error) in
                guard let jsonArray = responseJSON as? [String:Any] else { return }
                guard let userInfo = Mapper<LogInModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(userInfo)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func login(emailOrNumber: String, password: String) -> Observable<LogInModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.login(emailOrNumber: emailOrNumber, password: password, completion: { (responseJSON, error) in
                guard let jsonArray = responseJSON as? [String:Any] else { return }
                guard let userInfo = Mapper<LogInModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(userInfo)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    
}
