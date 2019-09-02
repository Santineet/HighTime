//
//  AgreementTVC.swift
//  HighTime
//
//  Created by Mairambek on 02/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class AgreementTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.estimatedRowHeight = 44.0

        
    }

    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath)
        return cell
    }
    
    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        
        return size
    }
    
   

}
