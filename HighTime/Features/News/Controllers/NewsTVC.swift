//
//  NewsTVC.swift
//  HighTime
//
//  Created by Mairambek on 17/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
import RxSwift


class NewsTVC: UITableViewController {
    
    var news: [NewsModel] = []
    let newsVM = NewsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        subscribeBehaviorRaplays()
        HUD.show(.progress)
       
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeBehaviorRaplays()
    }
    
    //MARK: - Method

    func subscribeBehaviorRaplays() {
        self.newsVM.getNews { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        self.newsVM.newsBehaviorRelay.skip(1).subscribe(onNext: { (allNews) in
            self.news = allNews
            HUD.hide()
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.newsVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    //MARK:  CellForRowAt
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTVCell", for: indexPath) as! NewsTVCell
        let news = self.news[indexPath.row]

        news.messageNews = news.messageNews.replacingOccurrences(of: "&amp;", with: " ")
        news.messageNews = news.messageNews.replacingOccurrences(of: "amp;", with: " ")
        news.messageNews = news.messageNews.replacingOccurrences(of: "nbsp;", with: " ")
        news.messageNews = news.messageNews.replacingOccurrences(of: "ndash;", with: " ")
        news.messageNews = news.messageNews.replacingOccurrences(of: "rsquo;", with: " ")
        news.messageNews = news.messageNews.replacingOccurrences(of: "  ", with: " ")
        
        cell.titleNews.text = news.titleNew
        cell.messageNews.text = news.messageNews
        cell.dateNews.text = "18-08-2019"
        let smallImage = news.imageSmall
        cell.imageNews.sd_setImage(with: URL(string: smallImage), placeholderImage: UIImage(named: ""))
        
        return cell
    }
    
    //MARK: heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185.0
    }
    
    //MARK: didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsId = self.news[indexPath.row]
        let newsDetailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsInfoTVC") as! NewsInfoTVC
        newsDetailVC.newsId = newsId
        newsDetailVC.allNews = self.news
        
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
        
    }
    
}
