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
    @IBOutlet weak var rePassword: UITextField!
    
    
    var loginVM = LoginViewModel()
    var userInfo = LogInModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alert.displayAlert(title: "", message: "Для Кыргызстана регистрация по номеру телефона либо по Эл. адресу для остальных по Эл. адресу", vc: self)
    }
    
    @IBAction func registryButton(_ sender: UIButton) {
        
        guard let name = self.name.text, self.name.text?.count != 0 else { return }
        guard var emailOrNumber = emailOrNumber.text else { return }
        guard let password = password.text else { return }
        guard let rePassword = rePassword.text else { return }
        
        let numberPhone = Int(emailOrNumber)
        if numberPhone != nil {
            if emailOrNumber.first == "0" {
                emailOrNumber.remove(at: emailOrNumber.startIndex)
                emailOrNumber = "996" + emailOrNumber
            } else if emailOrNumber.count != 12 {
                Alert.displayAlert(title: "Ошибка", message: "Не верно введен номер телефона", vc: self)
            }
        }
        
        
        if password != rePassword {
            Alert.displayAlert(title: "Внимание", message: "Пароли не совпадают", vc: self)
            return
        }
        
        if password.count < 8 {
            Alert.displayAlert(title: "Внимание", message: "Пароль должен содержать 8 и более символов", vc: self)
            return
        }
        
        if(!name.isEmpty && !emailOrNumber.isEmpty && !password.isEmpty && !rePassword.isEmpty){
            
            self.loginVM.alertRegister(title: "", message: "Вы прочитали условия Конфиденциальности по ссылке снизу и согласны с ними", vc: self) { (result) in
                if result == "OK" {
                    self.registration(name: name, emailOrNumber: emailOrNumber, password: password)
                }
            }
            
            
        }else{
            HUD.hide()
            Alert.displayAlert(title: "Ошибка", message: "Заполните все поля!", vc: self)
        }
        
        
    }
    
    func registration(name: String,emailOrNumber: String,password: String ){
        HUD.show(.progress)
        self.loginVM.registration(name: name, emailOrNumber: emailOrNumber, password: password) { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        self.loginVM.registrBehaviorRelay.skip(1).subscribe(onNext: { (userInfo) in
            self.userInfo = userInfo
            
            if userInfo.message == "" {
                self.getNewToken(emailOrNumber: emailOrNumber, password: password)
           
            }else{
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Такой E-mail уже зарегистрирован", vc: self)
            }
        }).disposed(by: disposeBag)
        
        self.loginVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }
    
    
    func getNewToken(emailOrNumber: String, password: String){
        self.loginVM.login(emailOrNumber: emailOrNumber, password: password) { (error) in
                HUD.hide()
        }
        
        self.loginVM.loginBehaviorRelay.skip(1).subscribe(onNext: { (userInfo) in
            if userInfo.error == "" {
                
                let userName = userInfo.user.name
                let userEmail = userInfo.user.email
                let token = userInfo.result.success.token
                
                UserDefaults.standard.setValue(userName, forKey: "userName")
                UserDefaults.standard.setValue(userEmail, forKey: "userEmail")
                UserDefaults.standard.setValue(token, forKey: "userToken")
                HUD.hide()
                LoginLogoutManager.instance.updateRootVC()
            }else{
                HUD.hide()
            }
        }).disposed(by: disposeBag)
        
        self.loginVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)

    }
    
    
    
}
