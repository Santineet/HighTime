//
//  NewsTVCell.swift
//  HighTime
//
//  Created by Mairambek on 17/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class NewsTVCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var messageNews: UILabel!
    @IBOutlet weak var dateNews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
