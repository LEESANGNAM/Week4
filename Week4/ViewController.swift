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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieList: [Movie] = []
    //codable
    var result: BoxOffice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.rowHeight = 60
        indicatorView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func callRequest(date: String){
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        AF.request(url, method: .get).validate()
            .responseDecodable(of: BoxOffice.self) { response in
                print(response.value)
                self.result = response.value
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true
                self.movieTableView.reloadData()
            }
        //            .responseJSON { response in
        //            switch response.result {
        //            case .success(let value):
        //                let json = JSON(value)
        //                print("JSON: \(json)")
        //
        ////                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
        ////                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
        ////                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
        ////
        ////                self.movieList.append(contentsOf: [name1,name2,name3])
        //
        //
        //                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
        //                    let title = item["movieNm"].stringValue
        //                    let release = item["openDt"].stringValue
        //                    let movie = Movie(movieTitle: title, release: release)
        //                    self.movieList.append(movie)
        //                }
        //
        //
        //
        //                self.indicatorView.stopAnimating()
        //                self.indicatorView.isHidden = true
        //                self.movieTableView.reloadData()
        //
        //            case .failure(let error):
        //                print(error)
        //            }
        //        }
    }
    
    
}
//MARK: - searchBar
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //20220101 > 1.8글자
        callRequest(date: searchBar.text!)
        
        
    }
    
    
}


extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.boxOfficeResult.dailyBoxOfficeList.count ?? 0//movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = result!.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        cell.detailTextLabel?.text = result!.boxOfficeResult.dailyBoxOfficeList[indexPath.row].openDt
        
        return cell
    }
    
    
    
    
}
