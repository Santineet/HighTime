//
//  LoginVC.swift
//  HighTime
//
//  Created by Mairambek on 14/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PKHUD
import RxSwift

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailOrNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var confidentiality: UIButton!
    
    var loginVM = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alert.displayAlert(title: "", message: "Для Кыргызстана вход по номеру телефона либо по Эл. адресу для остальных по Эл. адресу", vc: self)
    }
    
    @IBAction func logInButton(_ sender: Any) {
        HUD.show(.progress)
        
        guard var emailOrNumber = self.emailOrNumber.text else { return }
        guard let password = self.password.text else { return }
        
        let numberPhone = Int(emailOrNumber)
        if numberPhone != nil {
            if emailOrNumber.first == "0" {
                emailOrNumber.remove(at: emailOrNumber.startIndex)
                emailOrNumber = "996" + emailOrNumber
            } else if emailOrNumber.count != 12 {
                Alert.displayAlert(title: "Ошибка", message: "Не верно введен номер телефона", vc: self)
            }
            
        }
        
        if(!emailOrNumber.isEmpty && !password.isEmpty){
            self.loginVM.login(emailOrNumber: emailOrNumber, password: password) { (error) in
                if error != nil {
                    HUD.hide()
                    Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
                }
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
                    Alert.displayAlert(title: "Ошибка", message: "Не верный логин или пароль", vc: self)
                }
            }).disposed(by: disposeBag)
            
            self.loginVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
                HUD.hide()
                Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
            }).disposed(by: disposeBag)

        } else {
            HUD.hide()
            Alert.displayAlert(title: "Внимание", message: "Заполните все поля!", vc: self)
        }
    }
    
}
