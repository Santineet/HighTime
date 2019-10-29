//
//  LoginViewModel.swift
//  HighTime
//
//  Created by Mairambek on 15/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let loginBehaviorRelay = BehaviorRelay<LogInModel>(value: LogInModel())
    let registrBehaviorRelay = BehaviorRelay<LogInModel>(value: LogInModel())
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = LoginRepository()
    
    func registration(name:String, emailOrNumber: String,password: String,completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.registr(name: name, emailOrNumber: emailOrNumber, password: password).subscribe(onNext: { (userInfo) in
                self.registrBehaviorRelay.accept(userInfo)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Нет соединения"))
        }
    }
    
    func login(emailOrNumber: String,password: String,completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.login(emailOrNumber: emailOrNumber, password: password).subscribe(onNext: { (userInfo) in
                self.loginBehaviorRelay.accept(userInfo)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Нет соединения"))
        }
    }
    
    func alertRegister(title: String, message: String, vc: UIViewController, completion: @escaping (String) -> ()){
       
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Да", style: .default) { (UIAlertAction) in

            completion("OK")
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default) { (UIAlertAction) in
            completion("Cancel")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
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
