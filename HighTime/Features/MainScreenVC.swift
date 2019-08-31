//
//  MainScreenVC.swift
//  HighTime
//
//  Created by Mairambek on 14/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class MainScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.21, green: 0.48, blue: 0.96, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white ]
        navigationController?.navigationBar.tintColor = UIColor.white

    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")

        LoginLogoutManager.instance.updateRootVC()
    
    }
    


 
    
    
    }

