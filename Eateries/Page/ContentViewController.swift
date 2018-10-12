//
//  ContentViewController.swift
//  Eateries
//
//  Created by Виталий Охрименко on 26.04.2018.
//  Copyright © 2018 Ivan Akulov. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var subheaderlbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pageButton: UIButton!
    @IBOutlet weak var pageControll: UIPageControl!
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    @IBAction func pageBtnAction(_ sender: UIButton) {
        switch index {
        case 0:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 1:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "wasWatched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        pageButton.layer.borderColor = (#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)).cgColor
        
        switch index {
        case 0: pageButton.setTitle("Далее", for: .normal)
        case 1: pageButton.setTitle("Открыть", for: .normal)
        default:
            break
        }
        
        
        pageControll.numberOfPages = 2
        pageControll.currentPage = index
        
        
        headerLbl.text = header
        subheaderlbl.text = subheader
        imageView.image = UIImage(named: imageFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    

  

}
