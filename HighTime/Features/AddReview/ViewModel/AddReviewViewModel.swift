//
//  AddReviewViewModel.swift
//  HighTime
//
//  Created by Mairambek on 20/08/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import Alamofire

class AddReviewViewModel: NSObject{
    
    //    MARK:    Variables
    //    MARK:    Переменные
    var reachability:Reachability?
    
    func postReview(params: [String:Any], image: UIImage?,completion: @escaping (String?,Error?) -> ()){
        
        //Проверка интернета
        if self.isConnnected() == true {
            let createReviewURL = URL(string: "http://apitest.htlife.biz/api/reviews/create")
            if let image = image {
                
                //Функция для загрузки данных c image
                let token = UserDefaults.standard.value(forKey: "userToken")
                let headers:HTTPHeaders = ["token": "\(token ?? "")"]
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    
                    let imageData = image.jpegData(compressionQuality: 0.8)
                    
                    let randomString = self.randomStringWithLength(len: 20)
                    multipartFormData.append(imageData!, withName: "thumbnail", fileName: "\(randomString).jpeg", mimeType: "image/jpeg")
                    
                    for (key, value) in params {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }, to: createReviewURL!, headers:headers)
                { (result) in
                    switch result {
                    case .success(let upload,_,_ ):
                        upload.uploadProgress(closure: { (progress) in
                            
                        })
                        upload.responseJSON
                            { response in
                                if response.result.value != nil
                                {
                                    
                                    completion("success",nil)
                                }
                        }
                    case .failure(let encodingError):
                        print(encodingError.localizedDescription)
                        break
                    }
                }
                
                //Функция для загрузки данных без image
            } else {
                Alamofire.request(createReviewURL!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
                    { response in
                        switch response.result {
                        case .success:
                            completion("success",nil)
                            break
                        case .failure(let error):
                            completion(nil,error)
                        }
                }
            }
        } else {
            completion(nil, NSError.init(message: "Нет соединения"))
        }
    }
    
    //Метод для рандомного подбора названия для image
    func randomStringWithLength (len : Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }
    
    
    
    //    MARK:    Internet check function.
    //    MARK:    Функция для проверки интернета.
    func isConnnected() -> Bool{
        do {
            try reachability = Reachability.init()
            
            if (self.reachability?.connection) == .wifi || (self.reachability?.connection) == .cellular {
                return true
            } else if self.reachability?.connection == .unavailable {
                return false
            } else if self.reachability?.connection == .none {
                return false
            } else {
                return false
            }
        }catch{
            return false
        }
    }
    
}
