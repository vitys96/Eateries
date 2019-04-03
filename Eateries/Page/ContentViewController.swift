
import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var subheaderlbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageButton: UIButton!
    @IBOutlet weak var pageControll: UIPageControl!
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    @IBOutlet weak var backgrView: UIView!
    
    
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

        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 2
//        imageView.layer.borderColor = (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).cgColor
        
        

        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.layer.borderColor = (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).cgColor
        
        switch index {
        case 0: pageButton.isHidden = true
        case 1: pageButton.setTitle("Открыть", for: .normal)
        default:
            break
        }
        
        pageControll.numberOfPages = 2
        pageControll.currentPage = index
        
        
//        headerLbl.text = header
        subheaderlbl.text = subheader
        imageView.image = UIImage(named: imageFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    

  

}
