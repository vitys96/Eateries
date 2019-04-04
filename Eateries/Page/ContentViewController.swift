
import UIKit

class ContentViewController: UIViewController {

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

        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
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
        
        subheaderlbl.text = subheader
        imageView.image = UIImage(named: imageFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
}
