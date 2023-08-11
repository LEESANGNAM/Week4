//
//  VideoTableViewCell.swift
//  Week4
//
//  Created by 이상남 on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet var thumbnailImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 13)
        
        
        
    }
}
