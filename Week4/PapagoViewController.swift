//
//  PapagoViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Language: Int, CaseIterable{
    case ko,ja,zh_CN,zh_TW,hi,en,es,fr,de,pt,vi,id,fa,ar,mm,th,re,it,unk
    
    var lang: String{
        switch self{
        case .ko:
            return "한국어"
        case .ja:
            return "일본어"
        case .zh_CN:
            return "중국어간체"
        case .zh_TW:
            return "중국어번체"
        case .hi:
            return "힌디어"
        case .en:
            return "영어"
        case .es:
            return "스페인어"
        case .fr:
            return "프랑스어"
        case .de:
            return "독일어"
        case .pt:
            return "포르투갈어"
        case .vi:
            return "베트남어"
        case .id:
            return "인도네시아어"
        case .fa:
            return "페르시아어"
        case .ar:
            return "아랍어"
        case .mm:
            return "미얀마어"
        case .th:
            return "태국어"
        case .re:
            return "러시아어"
        case .it:
            return "이탈리아어"
        case .unk:
            return ""
        }
    }
}



class PapagoViewController: UIViewController {
    @IBOutlet weak var originalTextView: UITextView!
    
    @IBOutlet weak var translateTextView: UITextView!
    
    @IBOutlet weak var requstButton: UIButton!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectButtonText: UITextField!
    
    let pickerView = UIPickerView()
    
    let langList = Language.allCases
    
    let translateUrlEndPorint = "n2mt"
    let LanguageURL = "detectLangs"
    var beforeLang = ""
    var afterLang = ""
    let header: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.naverCilentId,
        "X-Naver-Client-Secret": APIKey.naverCilentPW
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsHelper.standard.nickname // UserDefaults.standard.string(forKey: "nickname")
        UserDefaultsHelper.standard.age // UserDefaults.standard.integer(forKey: "age")
        
        UserDefaultsHelper.standard.nickname = "칙촉"
        UserDefaultsHelper.standard.age = 30
        
        UserDefaults.standard.set("고래밥", forKey: "nickname")
        UserDefaults.standard.set(33, forKey: "age")
        
        UserDefaults.standard.string(forKey: "nickname")
        UserDefaults.standard.integer(forKey: "age")
        
        
        
        setUpUI()
        setupPickerView()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        originalTextView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false
        
        requstButton.setTitle("한국어 번역", for: .normal)
        selectButton.setTitle("다른언어 선택", for: .normal)
    }
    
    
    
    @IBAction func requestButtonTapped(_ sender: UIButton) {
        TranslateAPIManager.shared.callRequest(text: originalTextView.text ?? "") { string in
            self.translateTextView.text = string
        }
//        cllRequestLanguage(endPointText: LanguageURL)
    }
}

// MARK: - API
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
    
    func callRequest(endPointText: String, source: String, target: String = "ko"){
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
// MARK: - picker
extension PapagoViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    func setupPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
        selectButtonText.inputView = pickerView
        selectButtonText.tintColor = .clear
    }
    
    //돌아가는거 몇개
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    // 셀 몇개
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return langList.count - 1
    }
    
    // 선택
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let code = "\(langList[row])"
        if component == 0{
            beforeLang = code
        }else{
            afterLang = code
        }
        print("---------------")
        print(beforeLang)
        print(afterLang)
        
        
        if !beforeLang.isEmpty && !afterLang.isEmpty{
            callRequest(endPointText: translateUrlEndPorint, source: beforeLang,target: afterLang)
            beforeLang = ""
            afterLang = ""
            view.endEditing(true)
        }
        
    }
    
    
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return langList[row].lang
    }
    

    

    
    
}
