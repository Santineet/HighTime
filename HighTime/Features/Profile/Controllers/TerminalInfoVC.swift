//
//  TerminalInfoVC.swift
//  HighTime
//
//  Created by Mairambek on 02/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class TerminalInfoVC: UIViewController {

    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var accountNum = "??????"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountNumber.text = "Ваш лицевой счет\n" + accountNum
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    

    
}

extension TerminalInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2444
    }
    
    
    
}
