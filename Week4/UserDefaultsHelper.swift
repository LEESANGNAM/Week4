//
//  UserDefaultHelper.swift
//  Week4
//
//  Created by 이상남 on 2023/08/11.
//

import Foundation

class UserDefaultsHelper{ // PropertyWrapper
    
    static let standard = UserDefaultsHelper() // 싱글턴 패턴
    
    private init(){} // 접근제어자
    
    let userDefaults = UserDefaults.standard
    
    
    enum Key: String{ // 컴파일 최적화
        case nickname, age
    }
    
    var nickname: String{
        get{
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set{
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    var age: Int{
        get{
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
}
