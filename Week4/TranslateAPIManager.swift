//
//  TranslateAPIManager.swift
//  Week4
//
//  Created by 이상남 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class TranslateAPIManager {
    static let shared = TranslateAPIManager()
    
    private init() { }
    
    func callRequest(text : String, resultString: @escaping (String) -> Void){
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverCilentId,
            "X-Naver-Client-Secret": APIKey.naverCilentPW
        ]
        
        
        let parameters: Parameters = [
            "source": "en",
            "target": "ko",
            "text": text
        ]
        let url = "https://openapi.naver.com/v1/papago/" + "n2mt"
        
        AF.request(url, method: .post,parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                resultString(data)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}
