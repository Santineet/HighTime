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
    
    @IBOutlet weak var balanceInfo: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.logoutButton.addTarget(self, action: #selector(self.clickedButton), for: .touchUpInside)
    }
    
    @objc func clickedButton(){
        let token = UserDefaults.standard.value(forKey: "userToken") as! String
        UserDefaults.standard.removeObject(forKey: "\(token)myLevel")
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        LoginLogoutManager.instance.updateRootVC()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
