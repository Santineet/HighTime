//
//  CellForCollectioView.swift
//  HighTime
//
//  Created by Mairambek on 26/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class CellForCollectioView: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func reloadData(){
        print("ReloadData")
            self.collectionView.reloadData()
    }
    
}
