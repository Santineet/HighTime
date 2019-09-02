//
//  LevelsVC.swift
//  HighTime
//
//  Created by Mairambek on 26/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD
import SDWebImage

class LevelsVC: UIViewController {

    //Outlets
    @IBOutlet weak var alphabetLevel: UIButton!
    @IBOutlet weak var beginnerLevel: UIButton!
    @IBOutlet weak var preIntermediateLevel: UIButton!
    @IBOutlet weak var intermediateLevel: UIButton!
    @IBOutlet weak var upperIntermediateLevel: UIButton!
    @IBOutlet weak var advancedLevel: UIButton!
  
    var levels = [LevelsModel]()
    let levelsVM = LevelsViewModel()
    let disposeBag = DisposeBag()
    var isOpen = [LevelsModel]()
    var buttonArray: [UIButton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress)
        navigationItem.title = "Обучение"
        setupPressLevelButton()
        subscribeBehaviorRaplays()
        getLevelIsOpen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeBehaviorRaplays()
        getLevelIsOpen()
    }
    
    
    func subscribeBehaviorRaplays() {
        self.levelsVM.getLevels { (error) in
            if error != nil {
                HUD.hide()
                guard let navCont = self.navigationController else { return }
                Alert.alertForTests(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self, navCont: navCont)
            }
        }
        
        self.levelsVM.levelsBehaviorRelay.skip(1).subscribe(onNext: { (levelsInfo) in
            self.levels = levelsInfo
            self.setupLevelsButtonImage()
            HUD.hide()
        }).disposed(by: disposeBag)
        
        self.levelsVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
        }).disposed(by: disposeBag)
        
        
    }
    
    //MARK: getLevelIsOpen
    func getLevelIsOpen(){
        self.levelsVM.getLevelIsOpen()
        self.levelsVM.isOpenBehaviorRelay.skip(1).subscribe(onNext: { (isOpenLevels) in
            self.isOpen = isOpenLevels
            for isOpenLevel in self.isOpen {
                if isOpenLevel.name == "Alphabet" {
                    self.alphabetLevel.setImage(UIImage(named: "alphabetColor.png"), for: .normal)
                } else if isOpenLevel.name == "Beginner" {
                     self.beginnerLevel.setImage(UIImage(named: "beginnerColor.png"), for: .normal)
                } else if isOpenLevel.name == "Pre-Intermediate" {
                     self.preIntermediateLevel.setImage(UIImage(named: "preIntermediateColor.png"), for: .normal)
                } else if isOpenLevel.name == "Intermediate" {
                    self.intermediateLevel.setImage(UIImage(named: "intermediateColor.png"), for: .normal)
                } else if isOpenLevel.name == "Upper-Intermediate" {
                    self.upperIntermediateLevel.setImage(UIImage(named: "upperIntermediateColor"), for: .normal)
                } else if isOpenLevel.name == "Advanced"{
                    self.advancedLevel.setImage(UIImage(named: "advancedColor.png"), for: .normal)
                }
            }
         }).disposed(by: disposeBag)
        
        self.levelsVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
        }).disposed(by: disposeBag)
        
    }
    
    
    //MARK: setupLevelsButtonImage
    func setupLevelsButtonImage(){
     buttonArray = [self.alphabetLevel, self.beginnerLevel, self.preIntermediateLevel, self.intermediateLevel, self.upperIntermediateLevel, self.advancedLevel]
        let colorImagesArray = ["alphabetColor.png","beginnerColor.png","preIntermediateColor.png","intermediateColor.png","upperIntermediateColor","advancedColor.png"]
       let token = UserDefaults.standard.value(forKey: "userToken") as! String
        if UserDefaults.standard.value(forKey: "\(token)myLevel") != nil {
        let myLevel: Int = UserDefaults.standard.value(forKey: "\(token)myLevel") as! Int
            buttonArray![myLevel].setImage(UIImage(named: colorImagesArray[myLevel]), for: .normal)
            }
        }
        
    
    
    func setupPressLevelButton(){
        self.alphabetLevel.tag = 0
        self.beginnerLevel.tag = 1
        self.preIntermediateLevel.tag = 2
        self.intermediateLevel.tag = 3
        self.upperIntermediateLevel.tag = 4
        self.advancedLevel.tag = 5
        
        self.alphabetLevel.addTarget(self, action: #selector(didTappedLevelButton(sender:)), for: .touchUpInside)
        self.beginnerLevel.addTarget(self, action: #selector(didTappedLevelButton(sender:)), for: .touchUpInside)
        self.preIntermediateLevel.addTarget(self, action: #selector(didTappedLevelButton(sender:)), for: .touchUpInside)
        self.intermediateLevel.addTarget(self, action: #selector(didTappedLevelButton(sender:)), for: .touchUpInside)
        self.upperIntermediateLevel.addTarget(self, action: #selector(didTappedLevelButton(sender:)), for: .touchUpInside)
        self.advancedLevel.addTarget(self, action: #selector(didTappedLevelButton(sender:)), for: .touchUpInside)
        
    }
    
    @objc func didTappedLevelButton(sender: UIButton){
       
        let levelInfoTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LevelInfoTVC") as! LevelInfoTVC

        let oldContent = levels[sender.tag].content
        var newContent = oldContent.replacingOccurrences(of: "&amp;", with: " ")
        newContent = newContent.replacingOccurrences(of: "amp;", with: "")
        newContent = newContent.replacingOccurrences(of: "bull;", with: " ")
        newContent = newContent.replacingOccurrences(of: "nbsp;", with: "")
        levels[sender.tag].content = newContent

        levelInfoTVC.levelInfo = levels[sender.tag]
            
        navigationController?.pushViewController(levelInfoTVC, animated: true)
    }

    
}
