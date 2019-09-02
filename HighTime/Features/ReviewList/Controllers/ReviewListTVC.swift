//
//  ReviewListTVC.swift
//  HighTime
//
//  Created by Mairambek on 19/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift
import SDWebImage

class ReviewListTVC: UITableViewController {
    
    //    MARK:    Variables
    //    MARK:    Переменные
    var allReviews = [ReviewModel]()
    var reviewVM = ReviewViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.progress)
       
        subscribeBehaviorRaplays()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeBehaviorRaplays()
        self.tableView.allowsSelection = false
    }
    
    
    func subscribeBehaviorRaplays() {
        self.reviewVM.getReview { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        self.reviewVM.reviewBehaviorRelay.skip(1).subscribe(onNext: { (allReview) in
            self.allReviews = allReview
            HUD.hide()
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.reviewVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
        
    }
    
    @objc func sendReviewClicked(sender:Any){
        
        
        let addReviewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
        navigationController?.pushViewController(addReviewVC, animated: true)
    }
    
    // MARK:  numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReviews.count + 1
    }
    
    //MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var imageUrlCount = "imageUrlCount"
        if indexPath.row < allReviews.count{
            imageUrlCount = allReviews[indexPath.row].image
        }
        
        if indexPath.row == self.allReviews.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendReviewButtonTVCell", for: indexPath) as! SendReviewButtonTVCell
            
            cell.sendReview.tag = indexPath.row
            cell.sendReview.addTarget(self, action: #selector(sendReviewClicked(sender: ))
                , for: .touchUpInside)
            
            return cell
        } else if imageUrlCount.count > 35 {
            let review = allReviews[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewWithImageTVCell", for: indexPath) as! ReviewWithImageTVCell
            cell.date.text = review.date
            cell.loginName.text = "@" + review.name
            cell.time.text = review.time
            cell.textReview.text = review.comment
            let imageUrl = allReviews[indexPath.row].image
            cell.imageReview.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: ""))
            return cell
        } else if imageUrlCount.count <= 35 {
            let review = allReviews[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewWithOnlyTextTVCell", for: indexPath) as! ReviewWithOnlyTextTVCell
            cell.loginName.text = "@" + review.name
            cell.date.text = review.date
            cell.time.text = review.time
            cell.textReview.text = review.comment
            
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var imageUrlCount = "imageUrlCount"
        if indexPath.row < allReviews.count{
            imageUrlCount = allReviews[indexPath.row].image
        }
        
        if indexPath.row == self.allReviews.count{
            return 115.0
            
        } else if imageUrlCount.count <= 35 {
            let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 10.0)!, myText: allReviews[indexPath.row].comment)
            let labelWidth: CGFloat = UIScreen.main.bounds.width - 32.0
            let originalLabelHeight: CGFloat = 20.0
            let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
            let height =  75.0 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
            return height + 10.0
        } else if imageUrlCount.count > 35 {
            let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 12.0)!, myText: allReviews[indexPath.row].comment)
            let labelWidth: CGFloat = UIScreen.main.bounds.width - 32.0
            let originalLabelHeight: CGFloat = 20.0
            let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
            let height =  234.0 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
       
            return height + 10.0
        }
        return CGFloat()
        
    }
    
    //MARK: didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        return size
    }
    
}
