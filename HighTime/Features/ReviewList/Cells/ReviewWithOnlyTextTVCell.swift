//
//  ReviewWithOnlyTextTVCell.swift
//  HighTime
//
//  Created by Mairambek on 19/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class ReviewWithOnlyTextTVCell: UITableViewCell {

    @IBOutlet weak var loginName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textReview: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
