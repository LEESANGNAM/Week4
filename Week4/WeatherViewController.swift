//
//  WeatherViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        // Do any additional setup after loading the view.
    }
    
    
    func callRequest(){
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=\(APIKey.weatherKey)"
        
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let temp = json["main"]["temp"].doubleValue - 273.15
                let humidity = json["main"]["humidity"].doubleValue
                
                let id = json["weather"][0]["id"].intValue // 803번
            
                switch id {
                case 800: self.weatherLabel.text = "매우맑음"
                case 801...899: self.weatherLabel.text = "구름 많아요"
                default: print("나머지는 생략~")
                }
                
                self.tempLabel.text = "\(temp) 도 입니다."
                self.humidityLabel.text = "\(humidity)% 입니다."
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
