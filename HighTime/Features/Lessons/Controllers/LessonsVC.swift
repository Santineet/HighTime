//
//  LessonsVC.swift
//  HighTime
//
//  Created by Mairambek on 27/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD
import AVKit

class LessonsVC: UIViewController {
    
    @IBOutlet weak var lessonNumberImage: UILabel!
    @IBOutlet weak var lessonNumber: UILabel!
    @IBOutlet weak var viewForCells: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!

    var lessonId = Int()
    var lessonVM = LessonViewModel()
    var lesson = VideoTutorialByLessonIdModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress)
        getLessonTutorial(lessonId: lessonId)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func getLessonTutorial(lessonId: Int) {
        self.lessonVM.getLessonInfo(lessonId: lessonId) { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        self.lessonVM.lessonBehaviorRelay.skip(1).subscribe(onNext: { (lesson) in
            self.lesson = lesson
            self.viewForCells.frame = CGRect(x: 16, y: 100, width: Int(self.view.frame.width) - 32, height: 64 * lesson.videos.count + 150)
            self.setupView()
            self.tableView.reloadData()
            HUD.hide()
        }).disposed(by: self.disposeBag)
        
        self.lessonVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }
    
    func setupView(){
        
        if lessonId <= 27 {
            self.lessonNumber.text = "Буква \(self.lesson.name) "
        } else {
            self.lessonNumber.text = self.lesson.name
        }
        var contentRect = CGRect.zero
        contentRect = contentRect.union(viewForCells.frame)
        self.scrollView.contentSize = contentRect.size
        
        let lessonName = self.lesson.name.replacingOccurrences(of: "Урок ", with: "")
        self.lessonNumberImage.text = lessonName
    }
    
    
    
}

extension LessonsVC: UITableViewDelegate,UITableViewDataSource {
    
    
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lesson.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonListTVCell", for: indexPath) as! LessonListTVCell
        let name  = lesson.videos[indexPath.row].name
        cell.videoTutorial.text = name
        return cell
    }
    
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        if lesson.videos[indexPath.row].type == "test" {
            let passLevelTestVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassLessonTestVC") as! PassLessonTestVC
            passLevelTestVC.test = lesson.videos[indexPath.row]
            navigationController?.pushViewController(passLevelTestVC, animated:true)
        } else {
            
            let lessonVideoString = lesson.videos[indexPath.row].urlLowVideo.replacingOccurrences(of: " ", with: "%20")
            print(lessonVideoString)
            guard let videoURL = URL(string: "\(lessonVideoString)") else { return }
            let video = AVPlayer(url: videoURL)
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
           
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            }
            catch {
                Alert.displayAlert(title: "Ошибка", message: "Извините произошла ошибка, попробуйте позже", vc: self)
            }
            present(videoPlayer, animated: true) {
                video.play()
            }
            
        }
        
    }
    
    //MARK: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    
}
