//
//  Alert.swift
//  BitcoinTest
//
//  Created by Kuba Kadyrbekov on 7/30/19.
//  Copyright © 2019 Kuba Kadyrbekov. All rights reserved.
//

import UIKit

struct Alert {
    static func displayAlert(title: String, message: String, vc: UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func alertForTests(title: String, message: String, vc: UIViewController, navCont: UINavigationController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            navCont.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
}
