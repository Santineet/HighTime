//
//  TestWithImagesTVCell.swift
//  HighTime
//
//  Created by Mairambek on 03/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import MBRadioButton

class TestWithImagesTVCell: UITableViewCell, RadioButtonDelegate {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var firstAnswer: RadioButton!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var secondAnswer: RadioButton!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var thirdAnswer: RadioButton!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var fourthAnswer: RadioButton!
    
    var viewContainerCell = RadioButtonContainer()
    var answersButtonArray:[RadioButton] = []
    var link: PassLessonTestVC?
    var imagesArray:[UIImageView] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainerCell.delegate = self
        answersButtonArray = [firstAnswer,secondAnswer,thirdAnswer,fourthAnswer]
        viewContainerCell.addButtons(answersButtonArray)
       imagesArray = [firstImage,secondImage,thirdImage,fourthImage]
        firstAnswer.tag = 1
        secondAnswer.tag = 2
        thirdAnswer.tag = 3
        fourthAnswer.tag = 4
        
        firstAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        secondAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        thirdAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        fourthAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        
    }
    
    @objc func didTappedAnswerButton(sender:RadioButton){
        link?.didTappedAnswerButton(answerButton: sender, cell: self)
    }
    
    func radioButtonDidSelect(_ button: RadioButton) {
        button.setTitleColor(UIColor(red: 0.21, green: 0.48, blue: 0.96, alpha: 1), for: .normal)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        button.setTitleColor( UIColor(red: 0.43, green: 0.43, blue: 0.44, alpha: 1), for: .normal)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
