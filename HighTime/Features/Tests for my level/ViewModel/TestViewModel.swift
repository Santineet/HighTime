//
//  TestViewModel.swift
//  HighTime
//
//  Created by Mairambek on 22/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TestViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let testBehaviorRelay = BehaviorRelay<[PassTestModel]>(value: [])
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = TestRepository()
    
    func getTest(completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getTests().subscribe(onNext: { (questions) in
                self.testBehaviorRelay.accept(questions)
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
