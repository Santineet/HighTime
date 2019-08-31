
import UIKit
import Alamofire
import ObjectMapper

//#if DEBUG
//let baseUrl = ""
//#else
//let baseUrl = ""
//#endif



class ServiceManager: NSObject {
    
    static let sharedInstance = ServiceManager()
    typealias Completion = (_ response: Any?, _ error: Error?) -> ()


    //MARK: Login Methods
    
    func signIn(emailOrNumber: String, password: String, onCompletion: @escaping (([String: AnyObject]) -> Void), onError: @escaping ((String?) -> Void)) {
        
        let APIaddress =  "http://apitest.htlife.biz/api/auth/login"
        
        let headers: HTTPHeaders = [
            "Accept": "*/*"
        ]
        
        let data = [
            "username": "sa@gmail.com",
            "password": "qwerty"
            ] as [String: String]
        
        Alamofire.request(APIaddress, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            
            case .success:
                guard var result = response.result.value as? [String: AnyObject] else { return }
                
                if  result["result"] != nil {
                    let data = result["result"]
                    if let session = Mapper<LoginSuccess>().map(JSON: data as! [String : Any]) {
                        print("Token: \(String(describing: session.success?.user_token))")
                        onCompletion(data as! [String : AnyObject])
                        LoginLogoutManager.instance.updateRootVC()

                    }
                    return
                } else {

                }
                
            case .failure(let error):
                onError(error.localizedDescription)
                return
            }
            
            
        }
        
    }
    
    //MARK: Запрос новостей
    //MARK: News Request
    func getNews(completion: @escaping Completion) {
        
        guard let newsUrl = URL(string: "http://apitest.htlife.biz/api/news/") else { return }

        Alamofire.request(newsUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                 completion(nil, error)
            }
        }
    }
    
    
    //MARK: Запрос отзывов
    //MARK: Reviews Request
    func getReviewList(completion: @escaping Completion){
         guard let reviewUrl = URL(string: "http://apitest.htlife.biz/api/reviews/list") else { return }
        
        Alamofire.request(reviewUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    //MARK: Запрос Teстов
    //MARK: Tests Request
  
        func getTest(completion: @escaping Completion){
            let token = UserDefaults.standard.value(forKey: "userToken")
            let header: HTTPHeaders = ["token": "\(token ?? "")"]
       
            let testRequestURL = URL(string: "http://apitest.htlife.biz/api/level-test/get-tests")
            Alamofire.request(testRequestURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (responseJSON) in
                switch responseJSON.result {
                case .success:
                    completion(responseJSON.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    
    
    //MARK: Запрос уровней
    //MARK: Levels Request
    func getLevels(completion: @escaping Completion) {
        let token = UserDefaults.standard.value(forKey: "userToken")
        let header: HTTPHeaders = ["token": "\(token ?? "")"]
        guard let levelsUrl = URL(string: "http://apitest.htlife.biz/api/level/") else { return }
        
        Alamofire.request(levelsUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    //MARK: Запрос информации уроков
    //MARK: Lesson info Request by level id
    func getLessonsInfoByLevelId(param: [String:Any],completion: @escaping Completion) {
        guard let lessonsUrl = URL(string: "http://apitest.htlife.biz/api/lesson/get-by-level/\(param["id"]!)") else { return }
        Alamofire.request(lessonsUrl, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                print("success")
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
  
    //MARK: Запрос информации покупок уровней
    func getLevelIsOpen(param: [String:Any], completion: @escaping Completion) {
        let token = UserDefaults.standard.value(forKey: "userToken")
        let header: HTTPHeaders = ["token": "\(token ?? "")"]
        guard let levelIsOpenUrl = URL(string: "http://apitest.htlife.biz/api/user/payment/check-payment/\(param["id"]!)") else { return }
        
        Alamofire.request(levelIsOpenUrl, method: .get, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    //MARK: Запрос контента урока уровня
    
    
    func getTutorialByLessonId(lessonId: Int, completion: @escaping Completion){
        let token = UserDefaults.standard.value(forKey: "userToken")
        let header: HTTPHeaders = ["token": "\(token ?? "")"]
        guard let lessonTutorialURL = URL(string: "http://apitest.htlife.biz/api/lesson/show/\(lessonId)") else { return }
        Alamofire.request(lessonTutorialURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func paymentWithPromocode(levelId: Int,promocode: String, completion: @escaping Completion) {
        let token = UserDefaults.standard.value(forKey: "userToken")
        let header: HTTPHeaders = ["token": "\(token ?? "")"]
        guard let lessonTutorialURL = URL(string: "http://apitest.htlife.biz/api/user/payment/by-with-promocode/\(levelId)/\(promocode)") else { return }
        
        Alamofire.request(lessonTutorialURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                print("errorr")
                completion(nil, error)
            }
        }
    }
    
    func getPaymentUrl(levelId: Int, completion: @escaping Completion){
        print("getPaymentUrl")

        let token = UserDefaults.standard.value(forKey: "userToken")
        let header: HTTPHeaders = ["token": "\(token ?? "")"]
        guard let lessonTutorialURL = URL(string: "http://apitest.htlife.biz/api/user/payment/by-with-paybox/\(levelId)") else { return }
        Alamofire.request(lessonTutorialURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
    //MARK: Запрос информации покупок уровней для профиля
    func getLevelsIsOpenForProfile( completion: @escaping Completion) {
        let token = UserDefaults.standard.value(forKey: "userToken")
        let header: HTTPHeaders = ["token": "\(token ?? "")"]
        guard let levelIsOpenUrl = URL(string: "http://apitest.htlife.biz/api/user/levels") else { return }
        
        Alamofire.request(levelIsOpenUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success:
                completion(responseJSON.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
    
}
