//
//  NewsInfoTVC.swift
//  HighTime
//
//  Created by Mairambek on 18/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


class NewsInfoTVC: UITableViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var newsImage: UIImageView!
    
    //MARK: Variables
    var newsId = NewsModel()
    var news = [NewsModel]()
    var allNews = [NewsModel]()
    var activitiUIController: UIActivityViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewsInfo()
        self.tableView.allowsSelection = false
    }
    
    
    
    //MARK:  Methods
    
    @IBAction func shareButton(_ sender: Any) {
        self.activitiUIController = UIActivityViewController(activityItems: [self.newsId.titleNew, self.newsId.contentNews], applicationActivities: nil)
        self.present(self.activitiUIController!, animated: true, completion: nil)
    }
    
    // setupNewsInfo << self.news.append(oneNews)>>
    func setupNewsInfo(){
        for i in 0..<allNews.count {
            let oneNews = allNews[i]
            if oneNews.id != self.newsId.id {
                self.news.append(oneNews)
            }
            tableView.reloadData()
        }
        
        let largeImage = self.newsId.imageLarge
        self.newsImage.sd_setImage(with: URL(string: largeImage), placeholderImage: UIImage(named: ""))
    }
    
    
    //MARK: heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 10.0)!, myText: newsId.contentNews)
            let labelWidth: CGFloat = UIScreen.main.bounds.width - 32.0
            let originalLabelHeight: CGFloat = 79
            let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
            let height =  185.0 - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
            
            return height + 56.0
            
        case 1:
            return 50
        default:
            return 185
        }
    }
    
    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count + 2
    }
    
    //MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsInfoTVCell", for: indexPath) as! NewsInfoTVCell
           
            var text = newsId.contentNews.replacingOccurrences(of: "&amp;", with: " ")
            text = text.replacingOccurrences(of: "amp;", with: " ")
            text = text.replacingOccurrences(of: "rsquo;", with: " ")
            text = text.replacingOccurrences(of: "nbsp;", with: " ")
            text = text.replacingOccurrences(of: "  ", with: " ")
            
            cell.titleNews.text = self.newsId.titleNew
            cell.contentNews.text = text
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherNewsTVCell", for: indexPath) as! OtherNewsTVCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherNewsInfoTVCell", for: indexPath)  as! OtherNewsInfoTVCell
        
        let detailsNews = self.news[indexPath.row - 2]
        let imageSmall = detailsNews.imageSmall
        
        cell.titleNews.text = detailsNews.titleNew
        cell.contentNews.text = detailsNews.messageNews
        
        cell.imageInfoNews.sd_setImage(with: URL(string: imageSmall), placeholderImage: UIImage(named: ""))
        
        return cell
        
    }
    
    //MARK: didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row - 2 < 0 {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        let newNewsId = news[indexPath.row - 2]
        let newsDetailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsInfoTVC") as! NewsInfoTVC
        newsDetailVC.news.removeAll()
        newsDetailVC.newsId = newNewsId
        newsDetailVC.allNews = self.allNews
        
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    
    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        
        return size
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
