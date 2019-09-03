//
//  ToContactUs.swift
//  HighTime
//
//  Created by Mairambek on 02/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class ToContactUs: UITableViewController {

    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var name: UITextField!
 
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
    }

    @IBAction func sendButton(_ sender: Any) {
   
        guard let name = self.name.text, self.name.text?.count != 0 else { return }
        guard let number = self.number.text, self.number.text?.count != 0 else { return }
        let sendMessage = "Hello, I want to get advice! my data: \(name), \(number)"
        let encodedData = sendMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        let urlString = "https://wa.me/996505444415?text=\(encodedData!)"
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
   
        let url  = NSURL(string: "https://m.facebook.com/hightime.kg/")
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL)
        }
        else
        {
            notHaveAppAlert(app: "Facebook")
        }
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
        let url  = NSURL(string: "https://wa.me/996505444415")
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
        let url  = NSURL(string: "https://www.youtube.com/channel/UCkzrjgeGDtRNRwA-5dQpX3w")
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL)
        }
        else
        {
            notHaveAppAlert(app: "YouTube")
        }
    }
    
 
    func notHaveAppAlert(app: String){
        let alert = UIAlertController(title: "Sorry", message: "Your device does not have \(app) installed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
