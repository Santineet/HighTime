//
//  RegistrationVC.swift
//  HighTime
//
//  Created by Mairambek on 14/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import RxSwift
import PKHUD


class RegistrationVC: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailOrNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registryButton: UIButton!
    
    
    var loginVM = LoginViewModel()
    var userInfo = LogInModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registryButton(_ sender: UIButton) {
        
        HUD.show(.progress)
        guard let name = self.name.text, self.name.text?.count != 0 else { return }
        guard let emailOrNumber = emailOrNumber.text else { return }
        guard let password = password.text else { return }
        
        if(!name.isEmpty && !emailOrNumber.isEmpty && !password.isEmpty){
            
            self.loginVM.registration(name: name, emailOrNumber: emailOrNumber, password: password) { (error) in
                if error != nil {
                    HUD.hide()
                    Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
                }
            }
            
            self.loginVM.registrBehaviorRelay.skip(1).subscribe(onNext: { (userInfo) in
                self.userInfo = userInfo
                
                if userInfo.message == "" {
                    
                    let userName = userInfo.user.name
                    let userEmail = userInfo.user.email
                    let token = userInfo.result.success.token
                    print(userName)
                    print(userEmail)
                    print(token)
                    
                    UserDefaults.standard.setValue(userName, forKey: "userName")
                    UserDefaults.standard.setValue(userEmail, forKey: "userEmail")
                    UserDefaults.standard.setValue(token, forKey: "userToken")
                    HUD.hide()
                    LoginLogoutManager.instance.updateRootVC()
                }else{
                    HUD.hide()
                    Alert.displayAlert(title: "Ошибка", message: "Такой E-mail уже зарегистрирован", vc: self)
                }
            }).disposed(by: disposeBag)
            
            self.loginVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
                HUD.hide()
                Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
            }).disposed(by: disposeBag)
        }else{
            HUD.hide()
            Alert.displayAlert(title: "Ошибка", message: "Заполните все поля!", vc: self)
        }
        
        
    }
    
    
}
