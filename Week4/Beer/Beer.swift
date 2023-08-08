//
//  Beer.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import Foundation


struct Beer {
    var name: String
    var slogan: String
    var description: String
    var urlString: String
    
    var url: URL{
        return URL(string: urlString)!
    }
}
