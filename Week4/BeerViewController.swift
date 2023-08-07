//
//  BeerViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {

    @IBOutlet weak var beerTitleLabel: UILabel!
    
    @IBOutlet weak var beerTegLineLabel: UILabel!
    
    @IBOutlet weak var beerImageView: UIImageView!
    
    @IBOutlet weak var beerButton: UIButton!
    
    
    @IBOutlet weak var beerDesctiptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func beerButtonTapped(_ sender: UIButton) {
        callRequest()
    }
    
    
    func callRequest(){
        let url = APIKey.beerURL
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let name = json[0]["name"].stringValue
                let tagline = json[0]["tagline"].stringValue
                let description = json[0]["description"].stringValue
                let url = json[0]["image_url"].stringValue
                
                print("name:\(name)/tagline:\(tagline)/description:\(description), /url:\(url)")
                
                self.beerTitleLabel.text = name
                self.beerTegLineLabel.text = tagline
                self.beerDesctiptionLabel.text = description
                self.setUpImage(urlString: url)
                
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setUpUI(){
        beerDesctiptionLabel.numberOfLines = 0
        beerButton.setTitle("다른거", for: .normal)
    }
    
    
    func setUpImage(urlString : String){
        let url = URL(string: urlString)
        beerImageView.kf.setImage(with: url)
    }

}
