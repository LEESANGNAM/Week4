//
//  beerDetailViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/09.
//

import UIKit
import Kingfisher

class beerDetailViewController: UIViewController {
    
    var beer: Beer?
    
    @IBOutlet weak var beerDetailTitle: UILabel!
    
    @IBOutlet weak var beerDetailSlogan: UILabel!
    
    @IBOutlet weak var beerDetailImage: UIImageView!
    
    @IBOutlet weak var beerDetailDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beerSetup()
        // Do any additional setup after loading the view.
    }
    
    
    func beerSetup(){
        guard let beer else { return }
        
        beerDetailTitle.text = beer.name
        beerDetailSlogan.text = beer.slogan
        beerDetailDescription.text = beer.description
        
        beerDetailImage.kf.setImage(with: beer.url)
        
        
        
    }
    
    


}
