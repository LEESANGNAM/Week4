//
//  AsyncViewController.swift
//  Week4
//
//  Created by 이상남 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {

    
    @IBOutlet var first: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var third: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.backgroundColor = .black
        DispatchQueue.main.async {
            self.first.layer.cornerRadius = self.first.bounds.width/2
        }
        // Do any additional setup after loading the view.
    }
    
    // sync async serial concurrent
    //UI freezing
    
    @IBAction func buttonTapped(_ sender: UIButton){
        let url = URL(string:"https://api.nasa.gov/assets/img/general/apod.jpg")!
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: url)
            DispatchQueue.main.async {
                self.first.image = UIImage(data: data)
            }
        }
        
    }
}
