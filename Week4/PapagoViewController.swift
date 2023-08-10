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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTextView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false
        requstButton.setTitle("번역하기!!!!!", for: .normal)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func requestButtonTapped(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverCilentId,
            "X-Naver-Client-Secret": APIKey.naverCilentPW
        ]
        let parameters: Parameters = [
            "source": "ko",
            "target": "en",
            "text": originalTextView.text ?? ""
        ]
        
        
        AF.request(url, method: .post,parameters: parameters ,headers: header).validate().responseJSON { response in
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
