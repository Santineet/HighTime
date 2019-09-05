//
//  PassLessonTestVC.swift
//  HighTime
//
//  Created by Mairambek on 28/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import MBRadioButton

class PassLessonTestVC: UIViewController {
    
    @IBOutlet weak var lessonNum: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var test = VideosModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        lessonNum.text = test.name
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        doneButton.addTarget(self, action: #selector(doneButtonClicked(sender:)), for: .touchUpInside)
    }
    
    //MARK: Button Clicked
    func didTappedAnswerButton(answerButton:RadioButton, cell:UITableViewCell){
        guard let  indexPathTapped = tableView.indexPath(for: cell) else {return}
        test.tests[indexPathTapped.row].isSelected = answerButton.tag
        let answerIndex = answerButton.tag - 1
        if test.tests[indexPathTapped.row].answers[answerIndex].correct == true {
            test.tests[indexPathTapped.row].isCorrect = true
        } else {
            test.tests[indexPathTapped.row].isCorrect = false
        }
    }
    
    @objc func doneButtonClicked(sender: UIButton){
        var corectAnswersNum = 0
        for i in 0..<test.tests.count{
            test.tests[i].isSelected = 0
            if test.tests[i].isCorrect == true {
                corectAnswersNum += 1
            } else if test.tests[i].isCorrect == false {
            } else if test.tests[i].isCorrect == nil {
                Alert.displayAlert(title: "Ошибка", message: "Ответьте на все вопросы", vc: self)
                return
            }
        }
        guard let navCont = navigationController else {return}
        Alert.alertForTests(title: "", message: "Количество правильных ответов: \(corectAnswersNum)", vc: self, navCont: navCont)
    }
    
    
}


extension PassLessonTestVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.tests.count
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.test.tests[indexPath.row].answers[0].thumbnail == "" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassLessonTestTVCell", for: indexPath) as! PassLessonTestTVCell
            cell.link = self
            let question = self.test.tests[indexPath.row]
            question.content = question.content.replacingOccurrences(of: "&amp;", with: " ")
            question.content = question.content.replacingOccurrences(of: "amp;", with: " ")
            question.content = question.content.replacingOccurrences(of: "nbsp;", with: " ")
            question.content = question.content.replacingOccurrences(of: "ndash;", with: " ")

            question.content = question.content.replacingOccurrences(of: "rsquo;", with: " ")
            question.content = question.content.replacingOccurrences(of: "  ", with: " ")
            
            cell.content.text = question.content
            //присваивание title button'aм
            for i in 0..<5{
                if i < question.answers.count {
                    
                    var buttonText = question.answers[i].name.replacingOccurrences(of: "&amp;", with: " ")
                    buttonText = buttonText.replacingOccurrences(of: "amp;", with: " ")
                    buttonText = buttonText.replacingOccurrences(of: "rsquo;", with: " ")
                    buttonText = buttonText.replacingOccurrences(of: "  ", with: " ")
                    
                    cell.answersButtonArray[i].setTitle(buttonText, for: .normal)
                    cell.answersButtonArray[i].isHidden = false
                } else {
                    cell.answersButtonArray[i].isHidden = true
                }
            }
            
            self.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
            
            return cell
        } else if self.test.tests[indexPath.row].answers[0].thumbnail != "" {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestWithImagesTVCell", for: indexPath) as! TestWithImagesTVCell
            cell.link = self
            let question = self.test.tests[indexPath.row]
            cell.content.text = question.content
            
            //присваивание title button'aм
            for i in 0..<4{
                if i < question.answers.count {
                    let imageURL = question.answers[i].thumbnail
                 
                    var buttonText = question.answers[i].name.replacingOccurrences(of: "&amp;", with: " ")
                    buttonText = buttonText.replacingOccurrences(of: "amp;", with: " ")
                    buttonText = buttonText.replacingOccurrences(of: "rsquo;", with: " ")
                    buttonText = buttonText.replacingOccurrences(of: "  ", with: " ")
                   
                    cell.answersButtonArray[i].setTitle(buttonText, for: .normal)
                    cell.answersButtonArray[i].isHidden = false
                    cell.imagesArray[i].isHidden = false
                    cell.imagesArray[i].sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: ""))
                } else {
                    cell.answersButtonArray[i].isHidden = true
                    cell.imagesArray[i].isHidden = true
                }
            }
            
            self.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
            return cell
        }
  
        return UITableViewCell()
    }
    
    //MARK: willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if let cell = cell as? TestWithImagesTVCell {
            let question = self.test.tests[indexPath.row]
          
            question.content = question.content.replacingOccurrences(of: "&amp;", with: " ")
            question.content = question.content.replacingOccurrences(of: "amp;", with: " ")
            question.content = question.content.replacingOccurrences(of: "nbsp;", with: " ")
            question.content = question.content.replacingOccurrences(of: "ndash;", with: " ")
            
            question.content = question.content.replacingOccurrences(of: "rsquo;", with: " ")
            question.content = question.content.replacingOccurrences(of: "  ", with: " ")
            
            cell.content.text = question.content
            
            if question.isSelected != 0 {
                let selectNum = question.isSelected - 1
                cell.viewContainerCell.selectedButton = cell.answersButtonArray[selectNum]
            } else {
                cell.viewContainerCell.selectedButton = nil
            }
        } else {
            guard let cell = cell as? PassLessonTestTVCell else {return}
            
            let question = self.test.tests[indexPath.row]
            cell.content.text = question.content
            
            if question.isSelected != 0 {
                let selectNum = question.isSelected - 1
                cell.viewContainerCell.selectedButton = cell.answersButtonArray[selectNum]
            } else {
                cell.viewContainerCell.selectedButton = nil
                
            }
        }
        
    }
    
    //MARK: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let questionText = test.tests[indexPath.row].content
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 14.0)!, myText: questionText)
        let labelWidth: CGFloat = UIScreen.main.bounds.width - 42.0
        let originalLabelHeight: CGFloat = 14.0
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))        
        
        let question = self.test.tests[indexPath.row]
        
        //MARK: Answers with image
        if question.answers[0].thumbnail != "" {
            if question.answers.count == 2 {
                let height = 319 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
                return height
            } else if  question.answers.count == 3 {
                let height = 439 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
                return height
            } else if question.answers.count == 4 {
                let height = 559 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
                return height
            } else {
                let height = 559 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
                return height
            }
        }
        
        //MARK: Answers without image
        if question.answers.count == 2 {
            let height = 134 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
            return height
        } else if  question.answers.count == 3 {
            let height = 175 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
            return height
        } else if question.answers.count == 4 {
            let height = 216 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
            return height
        } else if  question.answers.count == 5 {
            let height = 277 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
            return  height
        } else {
            return  100
        }
        
    }
    
    
    
   
    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        return size
    }
    
    
    
    
}
