//
//  LevelInfoTVC.swift
//  HighTime
//
//  Created by Mairambek on 26/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD
import StoreKit

class LevelInfoTVC: UITableViewController, UITextFieldDelegate {
    
    //Variables
    var levelInfo = LevelsModel()
    var lessons = [LessonInfoByLevelId]()
    let levelInfoVM = LevelInfoViewModel()
    var isOpen = LevelIsOpenModel()
    let disposeBag = DisposeBag()
  
    // IAP Manager
    let iapManager = IAPManager.shared
    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        getLevelInfo()
        navigationItem.title = levelInfo.name
        tableView.allowsSelection = false
        
        notificationCenter.addObserver(self, selector: #selector(reload), name: NSNotification.Name(IAPManager.productNotificationIdentifier), object: nil)

        
         notificationCenter.addObserver(self, selector: #selector(buyLevel), name: NSNotification.Name(IAPProducts.buyLevel.rawValue), object: nil)
        
    }
    
    //IAP deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: IAP Methods
    
//    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchases))
////    }
//
//    @objc private func restorePurchases() {
//        iapManager.restoreCompletedTransactions()
//    }

    @objc private func reload() {
        

    }
    
    @objc private func buyLevel() {
        print("продукт куплен")
        
        UserDefaults.standard.setValue(1, forKey: "level\(levelInfo.id)")
 
        self.tableView.reloadData()
        HUD.hide()
    }
    
    
    func getLevelInfo() {
        HUD.show(.progress)
        levelInfoVM.getLessonsByLevelId(levelId: levelInfo.id) { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        self.levelInfoVM.lessonsBehaviorRelay.skip(1).subscribe(onNext: { (lessonsInfo) in
            self.lessons = lessonsInfo
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForCollectioView") as! CellForCollectioView
            cell.reloadData()
            self.tableView.reloadData()
            HUD.hide()
        }).disposed(by: disposeBag)
        
        self.levelInfoVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
        
        levelInfoVM.getLevelIsOpen(levelId: levelInfo.id)
        levelInfoVM.isOpenBehaviorRelay.skip(1).subscribe(onNext: { (isOpen) in
            self.isOpen = isOpen

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForCollectioView") as! CellForCollectioView
            
            cell.reloadData()
            self.tableView.reloadData()
            HUD.hide()
            
        }).disposed(by: disposeBag)
        
    
        levelInfoVM.isOpenErrorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            
        }).disposed(by: disposeBag)
        
    }
    
    
    
    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let buyThisLevel = UserDefaults.standard.value(forKey: "level\(levelInfo.id)")

        if self.isOpen.isOpen == true || buyThisLevel != nil {
            return 3
        }
        
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let buyThisLevel = UserDefaults.standard.value(forKey: "level\(levelInfo.id)")
        
        //Если уровень активирован
        if self.isOpen.isOpen == true || buyThisLevel != nil {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LevelInfoTVCell", for: indexPath) as! LevelInfoTVCell
                let levelImageURL = URL(string:levelInfo.image)
                cell.levelImage.sd_setImage(with:levelImageURL, placeholderImage: UIImage(named: ""))
                cell.levelDescription.text = levelInfo.content
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "lessonLabelCell", for: indexPath) as! lessonLabelCell
                if levelInfo.id == 2 {
                    cell.lessonLabel.text = "УРОКИ ПО БУКВАМ"
                } else {
                    cell.lessonLabel.text = "УРОК №"
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCollectioView", for: indexPath) as! CellForCollectioView
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
            
        }
        
        //Если уровень не куплен
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LevelInfoTVCell", for: indexPath) as! LevelInfoTVCell
            let levelImageURL = URL(string:levelInfo.image)
            cell.levelImage.sd_setImage(with:levelImageURL, placeholderImage: UIImage(named: ""))
            cell.levelDescription.text = levelInfo.content
            return cell
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTVCell", for: indexPath) as! PaymentInfoTVCell
            cell.promoCode.delegate = self
            cell.price.text = String(levelInfo.price) + levelInfo.currencySymbol
            cell.durationVideo.text = levelInfo.duration + " часа видео"
            cell.lessonsCount.text = String(lessons.count) + " уроков"
            cell.sendPromoCode.addTarget(self, action: #selector(clickedSendPromocode(sender:)), for: .touchUpInside)
            cell.buyLevel.addTarget(self, action: #selector(self.clickedBuyLevelButton)
                , for: .touchUpInside)
            
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonLabelCell", for: indexPath) as! lessonLabelCell
            if levelInfo.id == 2 {
                cell.lessonLabel.text = "УРОКИ ПО БУКВАМ"
            } else {
                cell.lessonLabel.text = "УРОК №"
            }
            return cell
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCollectioView", for: indexPath) as! CellForCollectioView
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
        
            return cell
        
    }
    
    
    //MARK: heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let buyThisLevel = UserDefaults.standard.value(forKey: "level\(levelInfo.id)")

        //Если уровень куплен
        if self.isOpen.isOpen == true || buyThisLevel != nil {
            if indexPath.row == 0 {
                let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 14.0)!, myText: levelInfo.content)
                let labelWidth: CGFloat = UIScreen.main.bounds.width - 60.0
                let originalLabelHeight: CGFloat = 100.0
                let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
                let height =  343.0 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
                return height
            } else if indexPath.row == 1 {
                return 87
            } else {
                let height = self.calculateCellSize(numberOfCells: lessons.count)
                return CGFloat(height)
            }
            
        }

        //Если уровень не куплен
        if indexPath.row == 0 {
            let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 14.0)!, myText: levelInfo.content)
            let labelWidth: CGFloat = UIScreen.main.bounds.width - 60.0
            let originalLabelHeight: CGFloat = 100.0
            let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
            let height =  343.0 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
            return height
        } else if indexPath.row == 1{
            return 275.0
        } else if indexPath.row == 2 {
            return 87
        } else {
            let height = self.calculateCellSize(numberOfCells: lessons.count)
            return CGFloat(height)
        }
    }
    
    //IAP target function
    @objc func clickedBuyLevelButton(){
        HUD.show(.progress)
        HUD.hide(afterDelay: 25, completion: nil)
        
        if iapManager.products.count > 0 {
        let identifier = iapManager.products[0].productIdentifier
            
            iapManager.purchase(productWith: identifier)
        } else {
            HUD.hide()
            Alert.displayAlert(title: "", message: "Произошла ошибка, попробуйте позже", vc: self)
        }
    }
    
    
    //MARK: calculateCellSize
    func calculateCellSize(numberOfCells: Int) -> Int {
        let buttonSize = Int(view.bounds.width/3 - 40)
        let numberOfLines = Int(numberOfCells/4)
        var height: Int = 0
        if numberOfCells % 4 == 0 {
            height = numberOfLines * buttonSize
        } else {
            let numberOfLines = Int(numberOfCells/4)
            height = numberOfLines * buttonSize + buttonSize
        }
        return height
    }
    
    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        
        return size
    }
    
    
}

//MARK: extension
extension LevelInfoTVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: collection numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessons.count
    }
    
    //MARK: collection  cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lessonsCountCVCell", for: indexPath) as! lessonsCountCVCell
        cell.lessonButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.lessonButton.tag = indexPath.row
        cell.lessonButton.addTarget(self, action: #selector(clickedButton(sender:)), for: .touchUpInside)
        let title = lessons[indexPath.row].name.replacingOccurrences(of: "Урок ", with: "")
        cell.lessonButton.setTitle(title, for: .normal)
        
        let buyLevel = UserDefaults.standard.value(forKey: "level\(levelInfo.id)")
        
        if isOpen.isOpen == true || buyLevel != nil {
            cell.lessonButton.isEnabled = true
        } else {
            if indexPath.row < 2 {
                cell.lessonButton.isEnabled = true
            } else {
                cell.lessonButton.isEnabled = true
                cell.lessonButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.lessonButton.addTarget(self, action: #selector(clickedNotPurchasedLesson(sender:)), for: .touchUpInside)
                
            }
        }
        
        return cell
    }
    
    //MARK: clickedButtons
    @objc func clickedNotPurchasedLesson(sender: UIButton){
        Alert.displayAlert(title: "", message: "Купите уровень!", vc: self)
    }
    
    
    //MARK:  clickedButtons
    @objc func clickedButton(sender: UIButton){
        
        let lessonVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LessonsVC") as! LessonsVC
        
        let lessonId = lessons[sender.tag].id
        lessonVC.lessonId = lessonId
        navigationController?.pushViewController(lessonVC, animated: true)
    }
    
    @objc func clickedSendPromocode(sender: UIButton){
        
        HUD.show(.progress)
        let index = IndexPath(row: 1, section: 0)
        let cell: PaymentInfoTVCell = self.tableView.cellForRow(at: index) as! PaymentInfoTVCell
        
        guard let promocode = cell.promoCode.text, cell.promoCode.text != "" else {
            HUD.hide()
            Alert.displayAlert(title: "Внимание", message: "Введите промокод", vc: self)
            return
        }
        
        self.levelInfoVM.paymentWithPromocode(levelId: self.levelInfo.id ,promocode: promocode) { (error) in
            if error != nil {
                HUD.hide()

                Alert.displayAlert(title: "Error", message: error?.localizedDescription ?? "Извините произошла ошибка, попробуйте позже", vc: self)
            }
            
        }
        
        self.levelInfoVM.promocodeBehaviorRelay.skip(1).subscribe(onNext: { (success) in
            let paymentSuccess = success
            HUD.hide()
            
            if paymentSuccess.result == "Success" {
                Alert.displayAlert(title: "Внимание", message: "Вы открыли уровень по промокоду", vc: self)
                
                self.isOpen.isOpen = true
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTVCell") as! PaymentInfoTVCell
                cell.promoCode.text = ""
                self.getLevelInfo()
            } else if paymentSuccess.result == "Error"{
                HUD.hide()

                Alert.displayAlert(title: "Ошибка", message: "Промокод не найден", vc: self)

                let cell = self.tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTVCell") as! PaymentInfoTVCell
                cell.deleteText()
                self.tableView.reloadData()
            }
        }).disposed(by: self.disposeBag)
        
        self.levelInfoVM.promocodeErrorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()

            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            
        }).disposed(by: self.disposeBag)
    }
    
    
    //MARK: collection collectionViewLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/4 - 10, height: view.bounds.width/4 - 10)
    }
    
    
    
}
