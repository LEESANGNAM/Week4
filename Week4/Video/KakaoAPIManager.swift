//
//  KakaoAPIManager.swift
//  Week4
//
//  Created by 이상남 on 2023/08/11.
//

import Foundation
import Alamofire

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init(){ }
    
    let header: HTTPHeaders = ["Authorization":APIKey.KakaoKey]
    
    func callRequest(type: EndPoint, query: String,page: Int ,completionHandler: @escaping (Video) -> () ){
        let pageparam = "&size=10&page=\(page)"
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = type.requestURL + text + pageparam
        
        print(url)
        
        AF.request(url, method: .get,headers: header).validate(statusCode: 200...500).responseDecodable(of:Video.self) { response in
            switch response.result {
            case .success(let value):
//                guard let responseData = response.value else { return }
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}
