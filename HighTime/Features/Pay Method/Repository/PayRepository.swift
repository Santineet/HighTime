//
//  PayRepository.swift
//  HighTime
//
//  Created by Mairambek on 30/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class PayRepository: NSObject {
    
    func getPaymentURL(levelId: Int) -> Observable<PaymentURLModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getPaymentUrl(levelId: levelId, completion: { (response, error) in
                guard let jsonArray = response as? [String:Any] else { return }
                guard let url = Mapper<PaymentURLModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(url)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func getPay24(levelId: Int) -> Observable<PaymentURLModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.paymentWithPay24(levelId: levelId, completion: { (response, error) in
                guard let jsonArray = response as? [String:Any] else { return }
                guard let message = Mapper<PaymentURLModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(message)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    
    
}

