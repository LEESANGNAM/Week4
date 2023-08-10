//
//  VideoViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Video{
    let author: String
    let date: String
    let time: Int
    let thumbnail: String
    let title: String
    let link: String
    
    var contenString: String {
        return "\(author)| \(time)회 \n \(date)"
    }
    
    
}




class VideoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var videoTableView: UITableView!
    
    var videoList: [Video] = []
    var page = 1
    var isEnd = false // 현재 페이지가 마지막인지 점검하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.prefetchDataSource = self
        
        
        searchBar.delegate = self
        videoTableView.rowHeight = 140
    }
    
    
    func callRequest(query: String,page: Int){
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)"
        let header: HTTPHeaders = ["Authorization":APIKey.KakaoKey]
        
        print(url)
        
        AF.request(url, method: .get,headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                print(response.response?.statusCode) // 상태코드 번호
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200{
                    
                    self.isEnd = json["meta"]["is_end"].boolValue
                    
                    print(self.isEnd)
                    
                    for item in json["documents"].arrayValue{
                        let title = item["title"].stringValue
                        let author = item["author"].stringValue
                        let date = item["datetime"].stringValue
                        let time = item["play_time"].intValue
                        let thumbnail = item["thumbnail"].stringValue
                        let link = item["url"].stringValue
                        
                        let data = Video(author: author, date: date, time: time, thumbnail: thumbnail, title: title, link: link)
                        
                        self.videoList.append(data)
                    }
//                    print(self.videoList)
                    self.videoTableView.reloadData()
                }
                else {
                    print("문제가 발생했어요. 잠시 후 다시 시도해주세요!!")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - 테이블뷰
//UITableViewDataSource,UITableViewDataSourcePrefetching: iOS10이상 사용 가능한 프로토콜, cellforrowat 메서드가 호출 되기 전에 미리 호출
extension VideoViewController: UITableViewDelegate, UITableViewDataSource,UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].contenString
        if let url = URL(string: videoList[indexPath.row].thumbnail){
            cell.thumbnailImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    // videoList 갯수와 indexPath.row 위ㅣ를 비교해 마지막 스크롤 시점을 확인 -> 네크워크 요청 시도
    // page count
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths{
            if videoList.count - 1 == indexPath.row && page < 15 && !isEnd {
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    //취소기능: 직접 취소하는 기능을 구현해주어야 함!
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("====취소:\(indexPaths)")
    }
    
    
    
    
}

// MARK: - 테이블뷰
extension VideoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        videoList.removeAll()
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        callRequest(query: query, page: page)
    }
    
    
}

