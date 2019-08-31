//
//  PaymentInfoTVCell.swift
//  HighTime
//
//  Created by Mairambek on 26/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class PaymentInfoTVCell: UITableViewCell {

    @IBOutlet weak var durationVideo: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var promoCode: UITextField!
    @IBOutlet weak var sendPromoCode: UIButton!
    @IBOutlet weak var buyLevel: UIButton!
    @IBOutlet weak var lessonsCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
