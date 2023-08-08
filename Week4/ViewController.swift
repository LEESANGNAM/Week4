//
//  ViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie{
    var movieTitle: String
    var release: String
}



class ViewController: UIViewController {

    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.rowHeight = 60
        callRequest()
        // Do any additional setup after loading the view.
    }
    
    func callRequest(){
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=20120101"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//
//                self.movieList.append(contentsOf: [name1,name2,name3])
                
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let title = item["movieNm"].stringValue
                    let release = item["openDt"].stringValue
                    let movie = Movie(movieTitle: title, release: release)
                    self.movieList.append(movie)
                }
                
                
                
                
                
                self.movieTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = movieList[indexPath.row].movieTitle
        cell.detailTextLabel?.text = movieList[indexPath.row].release
        
        return cell
    }
    

    
    
}
