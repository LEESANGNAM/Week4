//
//  LottoViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var lottoLabel: UILabel!
    
    let pickerView = UIPickerView()
    
    var number: Int = 0
    
    var list: [Int] = Array(1...1079).reversed()
    //Array(repeating: 100, count: 1000)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        callRequest(number: 1079)
    }
    
    func callRequest(number: Int){
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                print("3")
                
                let date = json["drwNoDate"].stringValue
                
                let lottoNum1 = json["drwtNo1"].intValue
                let lottoNum2 = json["drwtNo2"].intValue
                let lottoNum3 = json["drwtNo3"].intValue
                let lottoNum4 = json["drwtNo4"].intValue
                let lottoNum5 = json["drwtNo5"].intValue
                let lottoNum6 = json["drwtNo6"].intValue
                let bounsNumber = json["bnusNo"].intValue
                
                
                self.lottoLabel.text = "날짜 : \(date) \n 해당회차 : \(number) \n 당첨번호 \n 1번 : \(lottoNum1) \n 2번 : \(lottoNum2)\n 3번 : \(lottoNum3)\n 4번 : \(lottoNum4)\n 5번 : \(lottoNum5)\n 6번 : \(lottoNum6)\n 보너스 번호:  \(bounsNumber)번"
                
            case .failure(let error):
                print(error)
            }
        }
    }
   
    
    
   

}


extension LottoViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    func setupPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
        
        numberTextField.inputView = pickerView
        numberTextField.tintColor = .clear
    }
    
    //돌아가는거 몇개
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 셀 몇개
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // 선택
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberTextField.text = "\(list[row])"
        number = list[row]
        
        callRequest(number: number)
    }
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(list[row])"
    }
    
    
    
}
