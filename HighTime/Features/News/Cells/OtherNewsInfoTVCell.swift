//
//  OtherNewsInfoTVCell.swift
//  HighTime
//
//  Created by Mairambek on 18/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class OtherNewsInfoTVCell: UITableViewCell {

    @IBOutlet weak var titleNews: UILabel!
    
    @IBOutlet weak var contentNews: UILabel!
    @IBOutlet weak var imageInfoNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
