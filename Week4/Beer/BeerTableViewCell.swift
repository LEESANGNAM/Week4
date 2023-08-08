//
//  BeerTableViewCell.swift
//  Week4
//
//  Created by 이상남 on 2023/08/08.
//

import UIKit
import Kingfisher

class BeerTableViewCell: UITableViewCell {

    @IBOutlet weak var beerPorsterImageView: UIImageView!
    
    @IBOutlet weak var beerTitleLabel: UILabel!
    
    @IBOutlet weak var beerSloganLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(beer:Beer){
        beerPorsterImageView.kf.setImage(with: beer.url)
        beerTitleLabel.text = beer.name
        beerSloganLabel.text = beer.slogan
    }
    
    
}
