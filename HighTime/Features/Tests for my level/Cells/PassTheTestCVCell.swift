//
//  PassTheTestCVCell.swift
//  HighTime
//
//  Created by Mairambek on 21/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import MBRadioButton

class PassTheTestCVCell: UICollectionViewCell, RadioButtonDelegate {
    

   //Outlets
    @IBOutlet weak var titleQuestion: UILabel!
    @IBOutlet weak var contentQuestion: UILabel!
    @IBOutlet weak var secondAnswer: RadioButton!
    @IBOutlet weak var firstAnswer: RadioButton!
    @IBOutlet weak var thirdAnswer: RadioButton!
    @IBOutlet weak var fourthAnswer: RadioButton!
    @IBOutlet weak var fifthAnswer: RadioButton!
    
    //Variables
    var viewContainerCell = RadioButtonContainer()
    var link: PassTheTestCVC?
    var answersButtonArray:[RadioButton] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainerCell.delegate = self

        answersButtonArray = [firstAnswer,secondAnswer,thirdAnswer,
                              fourthAnswer,fifthAnswer]
        viewContainerCell.addButtons(answersButtonArray)
       
        firstAnswer.tag = 1
        secondAnswer.tag = 2
        thirdAnswer.tag = 3
        fourthAnswer.tag = 4
        fifthAnswer.tag = 5
        
        firstAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        secondAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        thirdAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        fourthAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
        fifthAnswer.addTarget(self, action: #selector(didTappedAnswerButton(sender:)), for: .touchUpInside)
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

    class var identifier:String {
        return String(describing: self)
    }
    
    class var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    
}
