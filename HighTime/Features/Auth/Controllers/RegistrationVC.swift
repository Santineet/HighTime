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
import MMProgressHUD


class RegistrationVC: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailOrNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registryButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registryButton(_ sender: UIButton) {
  
        guard let name = self.name.text, self.name.text?.count != 0 else { return }
        guard let emailOrNumber = emailOrNumber.text else { return }
        guard let password = password.text else { return }
        
        if(!name.isEmpty && !emailOrNumber.isEmpty && !password.isEmpty){
        
            guard let url = URL(string: "http://apitest.htlife.biz/api/auth/register" ) else { return }

            let params = ["name": name,"email": emailOrNumber, "password": password] as [String:Any]
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
                { response in
                switch response.result {
                case .success:
                    
                    guard let jsonArray = response.result.value as? [String: Any] else { return }
                    if jsonArray["user"] != nil {
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
                        
                        if jsonArray["result"] != nil{
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
                        
                            LoginLogoutManager.instance.updateRootVC()
                    }
                    
                    } else {
                        Alert.displayAlert(title: "Ошибка", message: "Такой E-mail уже зарегистрирован", vc: self)
                    }
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

            
            
        }else{
            Alert.displayAlert(title: "Ошибка", message: "Заполните все поля!", vc: self)
        }
        
    
    }
    

}
