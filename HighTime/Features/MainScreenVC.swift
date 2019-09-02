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

    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var reviews: UIButton!
    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var contacts: UIButton!
    @IBOutlet weak var news: UIButton!
    @IBOutlet weak var ourBranches: UIButton!
    @IBOutlet weak var ourTeam: UIButton!
    @IBOutlet weak var students: UIButton!
    @IBOutlet weak var instruction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.21, green: 0.48, blue: 0.96, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white ]
        navigationController?.navigationBar.tintColor = UIColor.white

        let buttonArray = [aboutUsButton,students,instruction,ourBranches,ourTeam,news,contacts,profile,reviews] as [UIButton]
        
        for button in buttonArray {
            dropShadow(button: button)
            button.addTarget(self, action: #selector(HoldDown(sender:)), for: .touchDown )
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let buttonArray = [aboutUsButton,students,instruction,ourBranches,ourTeam,news,contacts,profile,reviews] as [UIButton]
        for button in buttonArray {
            dropShadow(button: button)
            button.addTarget(self, action: #selector(HoldDown(sender:)), for: .touchDown )
        }
    }
    
    @objc func HoldDown(sender:UIButton)
    {
        sender.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        sender.setBackgroundColor(color: UIColor(displayP3Red: 0.21, green: 0.48, blue: 0.96, alpha: 1.0), forState: UIControl.State.highlighted)

    }
    
    
    
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        let token = UserDefaults.standard.value(forKey: "userToken") as! String
        UserDefaults.standard.removeObject(forKey: "\(token)myLevel")
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        LoginLogoutManager.instance.updateRootVC()
    
    }
    
    func dropShadow(button: UIButton) {
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor(displayP3Red: 0.0, green: 0.64, blue: 1.0, alpha: 0.1).cgColor
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 8
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        button.showsTouchWhenHighlighted = false
    }
}


 
    
    


