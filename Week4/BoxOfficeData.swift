//
//  BoxOfficeData.swift
//  Week4
//
//  Created by 이상남 on 2023/08/14.
//

import Foundation

// MARK: - BoxOffice
struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
    let boxofficeType: String
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let salesChange, movieNm: String
    let rankOldAndNew: RankOldAndNew
    let salesAcc, rankInten, audiInten, salesInten: String
    let audiCnt, movieCD, openDt, rnum: String
    let showCnt, rank, salesShare, salesAmt: String
    let audiAcc, audiChange, scrnCnt: String

    enum CodingKeys: String, CodingKey {
        case salesChange, movieNm, rankOldAndNew, salesAcc, rankInten, audiInten, salesInten, audiCnt
        case movieCD = "movieCd"
        case openDt, rnum, showCnt, rank, salesShare, salesAmt, audiAcc, audiChange, scrnCnt
    }
}

enum RankOldAndNew: String, Codable {
    case old = "OLD"
}
