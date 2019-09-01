//
//  AddReviewVC.swift
//  HighTime
//
//  Created by Mairambek on 19/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD

class AddReviewVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    //    MARK:    Outlets
    //    MARK:    Выходные точки
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var commentReview: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addMediaFilesLabel: UILabel!
    
    //    MARK:    Variables
    //    MARK:    Переменные
    var addReviewVM = AddReviewViewModel()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pressAddimage()
        setupReviewVC()
    }
    
    func setupReviewVC(){
        
        let date = Date()
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        timeFormatter.dateFormat = "hh:mm"
        
        let dateResult = dateFormatter.string(from: date)
        let timeResult = timeFormatter.string(from: date)

        self.userName.text = "@" + (UserDefaults.standard.value(forKey: "userName") as! String)
        self.commentReview.delegate = self
        self.commentReview.text = " Введите текст..."
        self.commentReview.textColor = UIColor.lightGray
        self.date.text = dateResult
        self.time.text = timeResult
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func pressAddimage(){
        self.addImage.isUserInteractionEnabled = true
        self.addImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedProfileImageView)))
    }
    
   
    @IBAction func doneButton(_ sender: Any) {
        HUD.show(.progress)
        self.doneButton.isEnabled = false
        if UserDefaults.standard.value(forKey: "userToken") == nil {return}
        guard let text = self.commentReview.text, self.commentReview.text != " Введите текст..." else {
            self.doneButton.isEnabled = true
           HUD.hide()
            Alert.displayAlert(title: "", message: "Заполните все поля", vc: self)
            return
        }
        
        let userName = UserDefaults.standard.value(forKey: "userName")
        let params = ["title": userName!, "text": text]
        
        addReviewVM.postReview(params: params as [String : Any], image: self.selectedImage) { (result,error)  in
            if error != nil {
                HUD.hide()
                self.doneButton.isEnabled = true
                Alert.displayAlert(title: "Ошибка", message: error?.localizedDescription ?? "Для получения данных требуется подключение к интернету", vc: self)
            } else if result != nil {
                HUD.hide()
                guard let navCont = self.navigationController else { return }
                Alert.alertForTests(title: "", message: "Ваш отзыв добавлен", vc: self, navCont: navCont)
            }
        }
    }
    
    
  
    //    MARK:    Сlicked the addReview Image to select a photo for the profile.
    //    MARK:    Нажатие на изображение отзыва, чтобы выбрать фотографию для отзыва.
    @objc func didTappedProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.isEditing = true
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedFromImageFromPicker:UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedFromImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedFromImageFromPicker = originalImage
        }
        if let selectedImage = selectedFromImageFromPicker{

            setupReviewImageViewStyle()
            self.addImage.image = selectedImage
            self.selectedImage = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Настройка стиля картинки
    func setupReviewImageViewStyle(){
        self.addMediaFilesLabel.isHidden = true
        self.addImage.layer.cornerRadius = 12
        self.addImage.layer.borderWidth = 1
        self.addImage.layer.borderColor = UIColor(red: 0.21, green: 0.48, blue: 0.96, alpha: 1).cgColor
        self.addImage.translatesAutoresizingMaskIntoConstraints = false
        self.addImage.contentMode = .scaleToFill
    }
    
    
    
    //    MARK:    Select a photo in the gallery.
    //    MARK:    Выбрать фотографию в галерее.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
  
}
