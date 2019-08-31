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
import MMProgressHUD

class LevelInfoTVC: UITableViewController, UITextFieldDelegate {
    
    //Variables
    var levelInfo = LevelsModel()
    var lessons = [LessonInfoByLevelId]()
    let levelInfoVM = LevelInfoViewModel()
    var isOpen = LevelIsOpenModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress)
        getLevelInfo()
        navigationItem.title = levelInfo.name
        tableView.allowsSelection = false
    }
    

    
    func getLevelInfo() {
        levelInfoVM.getLessonsByLevelId(levelId: levelInfo.id) { (error) in
            if error != nil {
                HUD.hide()
                MMProgressHUD.show()
                MMProgressHUD.dismissWithError(error?.localizedDescription)
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
            print(error.localizedDescription)
            HUD.hide()
        }).disposed(by: disposeBag)
        
        
        levelInfoVM.getLevelIsOpen(levelId: levelInfo.id)
        levelInfoVM.isOpenBehaviorRelay.skip(1).subscribe(onNext: { (isOpen) in
            self.isOpen = isOpen
            if isOpen.isOpen == true {
                let token = UserDefaults.standard.value(forKey: "userToken") as! String
            UserDefaults.standard.set(1, forKey: "\(token)\(self.levelInfo.id)")
            }
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForCollectioView") as! CellForCollectioView
            
            cell.reloadData()
        }, onError: { (error) in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
        
    }
    
    
    
    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LevelInfoTVCell", for: indexPath) as! LevelInfoTVCell
            let levelImageURL = URL(string:levelInfo.image)
            cell.levelImage.sd_setImage(with:levelImageURL, placeholderImage: UIImage(named: ""))
            cell.levelDescription.text = levelInfo.content
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonLabelCell", for: indexPath) as! lessonLabelCell
            if levelInfo.id == 2 {
                cell.lessonLabel.text = "УРОКИ ПО БУКВАМ"
            } else {
                cell.lessonLabel.text = "УРОК №"
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCollectioView", for: indexPath) as! CellForCollectioView
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTVCell", for: indexPath) as! PaymentInfoTVCell
        cell.promoCode.delegate = self
        cell.price.text = String(levelInfo.price) + levelInfo.currencySymbol
        cell.durationVideo.text = levelInfo.duration + " часа видео"
        cell.lessonsCount.text = String(lessons.count) + " уроков"
        cell.sendPromoCode.addTarget(self, action: #selector(clickedSendPromocode(sender:)), for: .touchUpInside)
        cell.buyLevel.addTarget(self, action: #selector(self.clickedBuyLevelButton)
            , for: .touchUpInside)
        
        return cell
    }
    
    
    //MARK: heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        cell.lessonButton.tag = indexPath.row
        cell.lessonButton.addTarget(self, action: #selector(clickedButton(sender:)), for: .touchUpInside)
        let title = lessons[indexPath.row].name.replacingOccurrences(of: "Урок ", with: "")
        cell.lessonButton.setTitle(title, for: .normal)
        
        if isOpen.isOpen == true {
            cell.lessonButton.isEnabled = true
        } else {
            if indexPath.row < 2 {
                cell.lessonButton.isEnabled = true
            } else {
                cell.lessonButton.isEnabled = false
            }
        }
        
        return cell
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
                MMProgressHUD.show()
                MMProgressHUD.dismissWithError(error?.localizedDescription)
            }
            
        }
        
            self.levelInfoVM.promocodeBehaviorRelay.skip(1).subscribe(onNext: { (success) in
                let paymentSuccess = success
                print(success.result)
                HUD.hide()
                if paymentSuccess.result == "Success" {
                    Alert.displayAlert(title: "Внимание", message: "Вы открыли уровень по промокоду", vc: self)
                    
                    self.isOpen.isOpen = true
                    
                    self.getLevelInfo()
                } else if paymentSuccess.result == "Error"{
                    HUD.hide()
                    Alert.displayAlert(title: "Ошибка", message: "Промокод не найден", vc: self)
                }
            }).disposed(by: self.disposeBag)
        self.levelInfoVM.errorBehaviorRelay.subscribe(onNext: { (error) in
            print(error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    @objc func clickedBuyLevelButton(){
        let payVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PayMethodVC") as! PayMethodVC
        payVC.levelId = self.levelInfo.id
        navigationController?.pushViewController(payVC, animated: true)
    }
    
    
    //MARK: collection collectionViewLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/3 - 40, height: view.frame.width/3 - 40)
    }
    
    
}
