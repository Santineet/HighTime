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
    let colorImagesArray = ["Alphabet":"alphabetColor.png", "Beginner":"beginnerColor.png", "Pre-Intermediate":"preIntermediateColor.png", "Intermediate":"intermediateColor.png", "Upper-Intermediate":"upperIntermediateColor", "Advanced":"advancedColor.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()
        HUD.show(.progress)
        getMyLevels()
    }
    
    func getMyLevels(){
        self.profileVM.getLevels { (error) in
            if error != nil {
                HUD.hide()
                print(error?.localizedDescription ?? "error")
            }
        }
        
        self.profileVM.myLevelsBehaviorRelay.skip(1).subscribe(onNext: { (myLevels) in
            self.myLevels = myLevels
            print(self.myLevels[1].name)
            self.setupMyLevels()
            HUD.hide()
        }).disposed(by: disposeBag)
        
        self.profileVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            print(error.localizedDescription)
            HUD.hide()
        }).disposed(by: disposeBag)
        
    }
    
    
    func setupMyLevels(){
        var numArray = ["0","0","0","0","0","0"]
        for oneLevel in self.myLevels{
            if oneLevel.name == "Alphabet" {
                numArray[0] = "Alphabet"
            } else if oneLevel.name == "Beginner" {
                numArray[1] = "Beginner"
            } else if oneLevel.name == "Pre-Intermediate"{
                numArray[2] = "Pre-Intermediate"
            } else if oneLevel.name == "Intermediate"{
                numArray[3] = "Intermediate"
            } else if oneLevel.name == "Upper-Intermediate"{
                numArray[4] = "Upper-Intermediate"
            }  else if oneLevel.name == "Advanced"{
                numArray[5] = "Advanced"
            }
        }
        
        for i in numArray {
            if i != "0" {
               self.levelNames.append(i)
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    
    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 + levelNames.count
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
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLevelsTVCell", for: indexPath) as! MyLevelsTVCell
        let index = levelNames[indexPath.row - 1]
        let imageName = colorImagesArray[index]
        cell.levelImage.image = UIImage(named: imageName!)
        cell.name.text = levelNames[indexPath.row - 1]
        return cell
        
    }
    
    //MARK: heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 186
        }
        return 65
    }
    
    
    
}
