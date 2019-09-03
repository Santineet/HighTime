//
//  PayViewModel.swift
//  HighTime
//
//  Created by Mairambek on 30/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PayViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let payURLBehaviorRelay = BehaviorRelay<PaymentURLModel>(value: PaymentURLModel())
    let pay24BehaviorRelay = BehaviorRelay<PaymentURLModel>(value: PaymentURLModel())
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = PayRepository()
    
    func getPayURL(levelId: Int,  completion: @escaping (Error?) -> ()){
        if isConnnected() == true {
            self.repository.getPaymentURL(levelId: levelId).subscribe(onNext: { (url) in
                self.payURLBehaviorRelay.accept(url)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Нет соединения"))
        }
    }
    
    func getPay24(levelId: Int,  completion: @escaping (Error?) -> ()){
        if isConnnected() == true {
            self.repository.getPay24(levelId: levelId).subscribe(onNext: { (message) in
                self.pay24BehaviorRelay.accept(message)
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
    
    
    
    
    

