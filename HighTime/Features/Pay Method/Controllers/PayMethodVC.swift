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
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func getPayURL(levelId: Int){
        HUD.show(.progress)
        self.payVM.getPayURL(levelId: levelId) { (error) in
            if error != nil {
                HUD.hide()
            }
        }
            
            self.payVM.payBehaviorRelay.skip(1).subscribe(onNext: { (url) in
                HUD.hide()
                guard let url = URL(string: url.url) else { return }
                UIApplication.shared.open(url)
            }, onError: { (error) in
                print(error.localizedDescription)
                HUD.hide()
            }).disposed(by: self.disposeBag)
        
    }
    

    @IBAction func mastercard(_ sender: UIButton) {
        getPayURL(levelId: levelId)
    }
    
    @IBAction func visa(_ sender: Any) {
        getPayURL(levelId: levelId)
    }
 
    @IBAction func elsom(_ sender: Any) {
        getPayURL(levelId: levelId)
    }
    
    @IBAction func umai(_ sender: Any) {
        getPayURL(levelId: levelId)
    }
    
    @IBAction func pay24(_ sender: Any) {
    }
    
}
