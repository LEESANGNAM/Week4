//
//  VideoViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import UIKit
import Alamofire
import Kingfisher





class VideoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var videoTableView: UITableView!
    
    var videoList: [Document] = []
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
        
        KakaoAPIManager.shared.callRequest(type: .video, query: query,page: page) { json in
            self.videoList += json.documents
            self.videoTableView.reloadData()
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier) as? VideoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].changeFormatDateString()
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

// MARK: - 서치바
extension VideoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        videoList.removeAll()
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        callRequest(query: query, page: page)
    }
    
    
}


