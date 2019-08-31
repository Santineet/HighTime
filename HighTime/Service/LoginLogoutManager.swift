//
//  LoginLogoutManager.swift
//  BffClient
//
//  Created by Avazbek Kodiraliev on 6/10/19.
//  Copyright © 2019 Avazbek Kodiraliev. All rights reserved.
//

import UIKit


class LoginLogoutManager: NSObject {
    static let instance = LoginLogoutManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateRootVC() {
        if UserDefaults.standard.value(forKey: Constant.USER_TOKEN_KEY) == nil{
            let vc = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginOrRegisterVC") as! LoginOrRegisterVC
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreenVC") as! MainScreenVC
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
        }
        appDelegate.window?.makeKeyAndVisible()
    }
}
