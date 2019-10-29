//
//  LogOutTVCell.swift
//  HighTime
//
//  Created by Mairambek on 01/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class LogOutTVCell: UITableViewCell {
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var vc: ProfileTVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.logoutButton.addTarget(self, action: #selector(logoutAlert), for: .touchUpInside)
    }
    
    @objc func logoutAlert(){
        
        let alertController = UIAlertController(title: "Выйти", message: "Вы действительно хотите выйти?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Да", style: .default) { (UIAlertAction) in
            self.logout()
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
       
        alertController.addAction(OKAction)
        alertController.addAction(cancel)

        vc?.present(alertController, animated: true, completion: nil)
    }
    
     func logout(){
        let token = UserDefaults.standard.value(forKey: "userToken") as! String
        UserDefaults.standard.removeObject(forKey: "\(token)myLevel")
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        for i in 2..<8 {
            UserDefaults.standard.removeObject(forKey: "level\(i)")
            
        }
        
        LoginLogoutManager.instance.updateRootVC()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
