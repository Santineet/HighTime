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
            
            self.payVM.payURLBehaviorRelay.skip(1).subscribe(onNext: { (url) in
                HUD.hide()
                guard let url = URL(string: url.url) else { return }
                UIApplication.shared.open(url)
            }, onError: { (error) in
                print(error.localizedDescription)
                HUD.hide()
            }).disposed(by: self.disposeBag)
        
    }
    
    func getPay24(levelId: Int){
        HUD.show(.progress)
        self.payVM.getPay24(levelId: levelId) { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        self.payVM.pay24BehaviorRelay.skip(1).subscribe(onNext: { (message) in
            HUD.hide()

            if message.result == "Error" {
                
                Alert.displayAlert(title: "Ошибка", message: message.message , vc: self)
                
            } else if message.result == "Success" {
                
                let levelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LevelsVC") as! LevelsVC
                self.navigationController?.popToViewController(levelVC, animated: true)
            }
            
        }).disposed(by: self.disposeBag)
        
        self.payVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
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
        getPay24(levelId: levelId)
    }
    
}
