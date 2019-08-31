//
//  ToContactUsVC.swift
//  HighTime
//
//  Created by Mairambek on 17/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class ToContactUsVC: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func send(_ sender: UIButton) {
        
        guard let name = self.name.text, self.name.text?.count != 0 else { return }
        guard let number = self.phoneNumber.text, self.phoneNumber.text?.count != 0 else { return }
        let sendMessage = "Hello, I want to get advice! my data: \(name), \(number)"
        let encodedData = sendMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        let urlString = "https://wa.me/996555490390?text=\(encodedData!)"
        guard let url  = NSURL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url as URL)
        {
            UIApplication.shared.open(url as URL)
        }
        else
        {
            notHaveAppAlert(app: "WhatsApp")
        }
        
    }
    
    @IBAction func facebook(_ sender: Any) {
        
    }
    
    @IBAction func instagram(_ sender: Any) {
        let url  = NSURL(string: "https://www.instagram.com/hightime_world/?hl=ru")
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL)
        }
        else
        {
            notHaveAppAlert(app: "Instagram")
        }
        
    }
    
    @IBAction func whatsapp(_ sender: Any) {
        let url  = NSURL(string: "https://wa.me/996555490390")
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL)
        }
        else
        {
            notHaveAppAlert(app: "WhatsApp")
        }
        
    }
    
    @IBAction func youtube(_ sender: Any) {
        
        
    }
    
    func notHaveAppAlert(app: String){
        let alert = UIAlertController(title: "Sorry", message: "Your device does not have \(app) installed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
