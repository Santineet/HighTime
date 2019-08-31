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
import MMProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var emailOrNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var confidentiality: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func logInButton(_ sender: Any) {
   
        guard let emailOrNumber = self.emailOrNumber.text else { return }
        guard let password = self.password.text else { return }
    
        if(!emailOrNumber.isEmpty && !password.isEmpty){

            MMProgressHUD.show(withStatus: "Загрузка")
         let loginRequest = [
            "username" : emailOrNumber,
            "password" : password
        ] as [String: Any]
        
        guard let serverUrl = URL(string: "http://apitest.htlife.biz/api/auth/login") else { return }
        
            Alamofire.request(serverUrl, method: .post, parameters: loginRequest, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let jsonArray = response.result.value as? [String: Any] else { return }
                    if jsonArray["result"] != nil {
                        
                        //Вытаскиваем user_name and user_email
                        
                        let user = jsonArray["user"]
                        if let userInfo = Mapper<LogInModel>().map(JSON: user as! [String : Any]) {
                            guard let userName = userInfo.user_name else {
                                MMProgressHUD.dismissWithError("userName is nil")
                                return
                            }
                            guard let userEmail = userInfo.user_email else {
                                MMProgressHUD.dismissWithError("userEmail is nil")
                                return
                            }
                            
                            UserDefaults.standard.setValue(userEmail, forKey: "userEmail")
                            UserDefaults.standard.setValue(userName, forKey: "userName")
                        }
                        
                        
                        //Получаем user_token
                        let result = jsonArray["result"]
                        if let session = Mapper<LoginSuccess>().map(JSON: result as! [String : Any]) {
                            guard let token = session.success?.user_token else {
                                MMProgressHUD.dismissWithError("token is nil")
                                return
                            }
                            print("Token: \(token)")
                            UserDefaults.standard.setValue(token, forKey: "userToken")
                        } else {
                            MMProgressHUD.dismissWithError("token is nil")
                            return
                        }
                        
                        MMProgressHUD.dismiss(withSuccess: "")
                        LoginLogoutManager.instance.updateRootVC()
                    } else {
                        MMProgressHUD.dismiss()
                        Alert.displayAlert(title: "Ошибка", message: "Не верный логин или пароль!", vc: self)
                       
                    }
                    break
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
                
            }

        } else {
            Alert.displayAlert(title: "Внимание", message: "Заполните все поля!", vc: self)
        }
    }
    
}
