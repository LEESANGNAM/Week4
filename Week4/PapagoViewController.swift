//
//  PapagoViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON


class PapagoViewController: UIViewController {
    @IBOutlet weak var originalTextView: UITextView!
    
    @IBOutlet weak var translateTextView: UITextView!
    
    @IBOutlet weak var requstButton: UIButton!
    
    let translateUrlEndPorint = "n2mt"
    let LanguageURL = "detectLangs"
    
    let header: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.naverCilentId,
        "X-Naver-Client-Secret": APIKey.naverCilentPW
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTextView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false
        requstButton.setTitle("번역하기!!!!!", for: .normal)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func requestButtonTapped(_ sender: UIButton) {
        
       
        cllRequestLanguage(endPointText: LanguageURL)
        
        
       
        
        
    }
}


extension PapagoViewController {
   
    func cllRequestLanguage(endPointText: String){
        let url = "https://openapi.naver.com/v1/papago/" + endPointText
        
        let parameters: Parameters = [
            "query": originalTextView.text ?? ""
        ]
        AF.request(url, method: .post,parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let source = json["langCode"].stringValue
                self.callRequest(endPointText: self.translateUrlEndPorint, source: source)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callRequest(endPointText: String, source: String, target: String = "ja"){
        let parameters: Parameters = [
            "source": source,
            "target": target,
            "text": originalTextView.text ?? ""
        ]
        let url = "https://openapi.naver.com/v1/papago/" + endPointText
        
        AF.request(url, method: .post,parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                self.translateTextView.text = data
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
