//
//  KakaoAPIManager.swift
//  Week4
//
//  Created by 이상남 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init(){ }
    
    let header: HTTPHeaders = ["Authorization":APIKey.KakaoKey]
    
    func callRequest(type: EndPoint, query: String, completionHandler: @escaping (JSON) -> () ){
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = type.requestURL + text
        
        print(url)
        
        AF.request(url, method: .get,headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}
