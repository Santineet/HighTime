//
//  PayMethodVC.swift
//  HighTime
//
//  Created by Mairambek on 29/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class PayMethodVC: UIViewController {

    let payVM = PayViewModel()
    var levelId = Int()
    var url: String = ""
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPayURL(levelId: levelId)
    }

    
    func getPayURL(levelId: Int){
        HUD.show(.progress)
        self.payVM.getPayURL(levelId: levelId) { (error) in
            if error != nil {
                HUD.hide()
            }
        }
            
            self.payVM.payBehaviorRelay.skip(1).subscribe(onNext: { (url) in
                self.url = url.url
                print(self.url)
                HUD.hide()
            }, onError: { (error) in
                print(error.localizedDescription)
                HUD.hide()
            }).disposed(by: self.disposeBag)
        
    }
    

    @IBAction func mastercard(_ sender: UIButton) {
  
        guard let url = URL(string: self.url) else { return }
        UIApplication.shared.open(url)
    
    }
    
    @IBAction func visa(_ sender: Any) {
        guard let url = URL(string: self.url) else { return }
        UIApplication.shared.open(url)
    }
 
    @IBAction func elsom(_ sender: Any) {
        guard let url = URL(string: self.url) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func umai(_ sender: Any) {
        guard let url = URL(string: self.url) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func pay24(_ sender: Any) {
    }
    
}
