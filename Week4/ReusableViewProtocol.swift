//
//  ReusableViewProtocol.swift
//  Week4
//
//  Created by 이상남 on 2023/08/11.
//

import Foundation
import UIKit

protocol ReusablViewProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusablViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusablViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    
    
}
