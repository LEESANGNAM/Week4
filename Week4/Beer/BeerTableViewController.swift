//
//  BeerTableViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON


class BeerTableViewController: UITableViewController {

    
    var beerList: [Beer] = []
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // xib 로 테이블뷰 셀을 생성할 경우, 테이블뷰에 사용할 셀을 등록해주는 과정이 필요!
        setUpNavigationBar()
        setUpTableView()
        callRequest()
    }
    
    func setUpTableView(){
        let nib = UINib(nibName: "BeerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BeerTableViewCell")
        tableView.rowHeight = 200
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell", for: indexPath) as! BeerTableViewCell
        let beer = beerList[indexPath.row]
        cell.setUpCell(beer: beer)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "beerDetailViewController") as! beerDetailViewController
        vc.beer = beerList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    

}


extension BeerTableViewController {
    func callRequest(){
        let url = APIKey.beerListURL
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
                for item in json.arrayValue{
                    let name = item["name"].stringValue
                    let slogan = item["tagline"].stringValue
                    let description = item["description"].stringValue
                    let url = item["image_url"].stringValue
                    let beer = Beer(name: name, slogan: slogan, description: description, urlString: url)
                    self.beerList.append(beer)
                    self.count += 1
                }
                self.tableView.reloadData()
                print(self.count)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setUpNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "랜덤추천", style: .plain, target: self, action: #selector(randomBeer))
        title = "맥주리스트"
        navigationController?.navigationBar.barTintColor = .blue
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    @objc func randomBeer(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BeerRandomViewController") as? BeerRandomViewController else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
