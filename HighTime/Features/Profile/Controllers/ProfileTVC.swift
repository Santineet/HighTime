//
//  ProfileTVC.swift
//  HighTime
//
//  Created by Mairambek on 30/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class ProfileTVC: UITableViewController {
    
    
    let profileVM = ProfileViewModel()
    let disposeBag = DisposeBag()
    var levelNames = [String]()
    var myLevels = [LevelsModel]()
    var levelId = [Int]()
    var userInfo = UserInfoModel()
    let colorImagesArray = ["Alphabet":"alphabetColor.png", "Beginner":"beginnerColor.png", "Pre-Intermediate":"preIntermediateColor.png", "Intermediate":"intermediateColor.png", "Upper-Intermediate":"upperIntermediateColor", "Advanced":"advancedColor.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        HUD.show(.progress)
        getMyLevels()
        getUserInfo()
    }
    
    func getMyLevels(){
        HUD.hide(afterDelay: 3)
        self.profileVM.getLevels { (error) in
            if error != nil {
                HUD.hide()
                print(error?.localizedDescription ?? "error")
            }
        }
        self.profileVM.myLevelsBehaviorRelay.skip(1).subscribe(onNext: { (myLevels) in
            self.myLevels = myLevels
            self.setupMyLevels()
        }).disposed(by: disposeBag)
        
        self.profileVM.myLevelsErrorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription , vc: self)
        }).disposed(by: disposeBag)
        
    }
    
    func getUserInfo(){
        HUD.hide(afterDelay: 2.0)
        self.profileVM.getUserInfo { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        self.profileVM.userInfoBehaviorRelay.skip(1).subscribe(onNext: { (userInfo) in
            self.userInfo = userInfo
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.profileVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }
    
    
    func setupMyLevels(){
        var numArray = ["0","0","0","0","0","0"]
        var levelId = [0,0,0,0,0,0]
        
        for oneLevel in self.myLevels{
            if oneLevel.name == "Alphabet" {
                numArray[0] = "Alphabet"
                levelId[0] = 2
            } else if oneLevel.name == "Beginner" {
                numArray[1] = "Beginner"
                levelId[1] = 3
            } else if oneLevel.name == "Pre-Intermediate"{
                numArray[2] = "Pre-Intermediate"
                levelId[2] = 4
            } else if oneLevel.name == "Intermediate"{
                numArray[3] = "Intermediate"
                levelId[3] = 5
            } else if oneLevel.name == "Upper-Intermediate"{
                numArray[4] = "Upper-Intermediate"
                levelId[4] = 6
            }  else if oneLevel.name == "Advanced"{
                numArray[5] = "Advanced"
                levelId[5] = 7
            }
        }
        
        for i in 0..<numArray.count {
            if numArray[i] != "0" {
                self.levelNames.append(numArray[i])
            }
            if levelId[i] != 0 {
                self.levelId.append(levelId[i])
            }
        }
        
        
        self.tableView.reloadData()
        HUD.hide()
    }
    
    
    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2 + levelNames.count
    }
    
    //MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTVCell", for: indexPath) as! ProfileInfoTVCell
            let name = UserDefaults.standard.value(forKey: "userName") as! String
            let email = UserDefaults.standard.value(forKey: "userEmail") as! String
            cell.userName.text = name
            cell.userEmail.text = email
            
            return cell
        } else if indexPath.row == levelNames.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogOutTVCell", for: indexPath) as! LogOutTVCell
            cell.vc = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLevelsTVCell", for: indexPath) as! MyLevelsTVCell
        let index = levelNames[indexPath.row - 1]
        let imageName = colorImagesArray[index]
        cell.levelImage.image = UIImage(named: imageName!)
        cell.name.text = levelNames[indexPath.row - 1]
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row > 0  && indexPath.row < levelNames.count + 1{
            let level = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LevelInfoTVC") as! LevelInfoTVC
            
            let id = self.levelId[indexPath.row - 1]
            for i in 0..<myLevels.count{
                
                if myLevels[i].id == id {
                    
                    let oldContent = myLevels[i].content
                    var newContent = oldContent.replacingOccurrences(of: "&amp;", with: " ")
                    newContent = newContent.replacingOccurrences(of: "amp;", with: "")
                    newContent = newContent.replacingOccurrences(of: "bull;", with: " ")
                    newContent = newContent.replacingOccurrences(of: "nbsp;", with: "")
                    myLevels[i].content = newContent
                    
                    level.levelInfo = myLevels[i]
                    navigationController?.pushViewController(level, animated: true)
                    
                }
            }
            
            
            
        }
        
        
    }
    
    //MARK: heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 136
        } else if indexPath.row == levelNames.count + 1 {
            return 115
        }
        return 65
    }
    
    
}
