
import UIKit
import PCLBlurEffectAlert
import Cosmos

class TableViewController: UITableViewController{
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var Headerview : UIView!
    var NewHeaderLayer : CAShapeLayer!
    var toggleFavourite: Bool!
    
    
    
    private let Headerheight : CGFloat = 300
    private let Headercut : CGFloat = 50
    var restaurant: Restaurant?
    
    @IBOutlet weak var starBarBtnItem: UIBarButtonItem!
    
    
    
//    @IBAction func editRest(_ sender: UIBarButtonItem) {
//            performSegue(withIdentifier: "editRest", sender: self)
//    }
    
    
    @IBAction func starBarBtnItemAction(_ sender: UIBarButtonItem) {
        if restaurant?.isFavourite == false {
            
            restaurant?.isFavourite = true
            starBarBtnItem.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.7861729452)
            starBarBtnItem.image = UIImage(named: "starBarBtnItem2")
            //
            //            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //            let popularVC = storyBoard.instantiateViewController(withIdentifier: "PupularRestTableViewController") as! PupularRestTableViewController
            ////            popularVC.popularRests.append(restaurant!)
            //            popularVC.tableView.reloadData()
            //            let lala = PupularRestTableViewController()
            //            lala.popularRests.append(restaurant!)
            //            lala.tableView.reloadData()
            
            //            let alert = PCLBlurEffectAlert.Controller(title: "В избранном " + "\u{2B50}", message: "Заведение было добавлено в раздел избранное", effect: UIBlurEffect(style: .extraLight), style: .alert)
            ////            let alertAction = PCLBlurEffectAlert.Action(title: "OK", style: .cancel, handler: nil)
            //            let alertAction1 = PCLBlurEffectAlert.Action(title: "OK", style: .cancel, handler: nil)
            //            alert.addAction(alertAction1)
            //            alert.configure(cornerRadius: 20)
            //            alert.configure(buttonFont: [PCLBlurEffectAlert.ActionStyle.cancel : UIFont(name: "HelveticaNeue", size: 16)!], buttonTextColor: [PCLBlurEffectAlert.ActionStyle.cancel : UIColor.black], buttonDisableTextColor: [PCLBlurEffectAlert.ActionStyle.default : UIColor.red])
            ////            alert.configure(overlayBackgroundColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0.2152985873))
            //            alert.configure(titleFont: UIFont(name: "HelveticaNeue", size: 20)!, titleColor: .black)
            //            alert.configure(buttonFont: [PCLBlurEffectAlert.ActionStyle.default : UIFont(name: "HelveticaNeue", size: 16)!])
            //            alert.configure(backgroundColor: #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 0.79))
            //            alert.configure(buttonBackgroundColor: #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 0.79))
            //            alert.show()
            //            let timeAfter = DispatchTime.now() + 3
            //            DispatchQueue.main.asyncAfter(deadline: timeAfter){
            //                alert.dismiss(animated: true, completion: nil)
            //            }
            
        }
        else {
            starBarBtnItem.image = UIImage(named: "starBarBtnItem")
            starBarBtnItem.tintColor = .white
            restaurant?.isFavourite = false
            
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch restaurant?.isFavourite {
        case nil:
            restaurant?.isFavourite = false
            starBarBtnItem.tintColor = .white
            starBarBtnItem.image = UIImage(named: "starBarBtnItem")
        case true:
            starBarBtnItem.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.7861729452)
            starBarBtnItem.image = UIImage(named: "starBarBtnItem2")
            
        case false:
            starBarBtnItem.image = UIImage(named: "starBarBtnItem")
            starBarBtnItem.tintColor = .white
        default:
            break
        }
        
        self.title = restaurant!.name
        //        self.UpdateView()
        
        //        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.9608, green: 0.7059, blue: 0.2, alpha: 1)
        
        if restaurant?.isPhoto == false {
            imageView.contentMode = .scaleAspectFit
        }
        imageView.image = UIImage(data: restaurant!.image! as Data)

        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Tableview Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4:
            return 80
        case 5:
            if (restaurant?.isVisited)! {
                return 60
            }
            else {
                return 0
            }
        default:
            break
        }
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            cell?.keyImageView.image = UIImage(named: "type")
            cell?.valueLabel1.text = restaurant?.type
        case 1:
            cell?.keyImageView.image = UIImage(named: "help")
            cell?.valueLabel1.text = restaurant?.location
            
        case 2:
            cell?.keyImageView.image = UIImage(named: "pin")
            cell?.valueLabel1.textColor = .blue
            cell?.valueLabel1.text = "Открыть на карте"
        case 3:
            cell?.isSeparatorHidden = true
            cell?.keyImageView.image = UIImage(named: "isVisiting")
            cell?.valueLabel1.text = restaurant!.isVisited ? "Посещено" : "Не посещено"
        case 4:
            cell?.valueLabel1.isHidden = true
            cell?.keyImageView.image = UIImage()
            
            createBorderCell(cell: cell!)
            ratingCell(cell: cell!)
            
        case 5:
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if (restaurant?.isVisited)! {
                cell?.isSeparatorHidden = true
                cell?.keyImageView.image = UIImage(named: "ruble")
                cell?.valueLabel1.text = restaurant?.averageCheck
            }
            else {
                cell?.isHidden = true
            }
        case 6:
            cell?.isSeparatorHidden = true
            cell?.keyImageView.image = UIImage()
            cell?.valueLabel1.isHidden = true
            
            createBorderCell(cell: cell!)
            
            shareCell(cell: cell!)
            
        default:
            break
        }
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    func createBorderCell(cell: UITableViewCell) {
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 0.79)
        border.frame = CGRect(x: 0, y: -5, width: tableView.frame.size.width, height: 7)
        border.borderWidth = width
        cell.layer.addSublayer(border)
    }
    
    func ratingCell(cell: UITableViewCell) {
        let labelRatingStar = CosmosView()
        labelRatingStar.settings.updateOnTouch = false
        labelRatingStar.settings.starSize = 30
        
        cell.addSubview(labelRatingStar)
        labelRatingStar.translatesAutoresizingMaskIntoConstraints = false
        labelRatingStar.widthAnchor.constraint(equalToConstant: 200).isActive = true
        labelRatingStar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        labelRatingStar.centerXAnchor.constraint(equalTo: (cell.centerXAnchor), constant: 50).isActive = true
        labelRatingStar.centerYAnchor.constraint(equalTo: (cell.centerYAnchor), constant: 0).isActive = true
        
        switch restaurant?.star {
        case 0:
            labelRatingStar.rating = 0
        case 1:
            labelRatingStar.rating = 1
        case 2:
            labelRatingStar.rating = 2
        case 3:
            labelRatingStar.rating = 3
        case 4:
            labelRatingStar.rating = 4
        case 5:
            labelRatingStar.rating = 5
            
        default:
            break
        }
        
        labelRatingStar.text = "РЕЙТИНГ"
        labelRatingStar.settings.textFont = UIFont(name: "HelveticaNeue-Light", size: 17)!
        labelRatingStar.settings.textMargin = -255
    }
    
    func shareCell(cell: UITableViewCell) {
        let labelRating = UILabel()
        let shareImageView = UIImageView()
        
        labelRating.translatesAutoresizingMaskIntoConstraints = false
        labelRating.textAlignment = .center
        cell.addSubview(labelRating)
        labelRating.widthAnchor.constraint(equalToConstant: 130).isActive = true
        labelRating.heightAnchor.constraint(equalToConstant: 40).isActive = true
        labelRating.centerXAnchor.constraint(equalTo: (cell.centerXAnchor), constant: 0).isActive = true
        labelRating.centerYAnchor.constraint(equalTo: (cell.centerYAnchor), constant: 0).isActive = true
        labelRating.text = "ПОДЕЛИТЬСЯ"
        labelRating.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        labelRating.isEnabled = false
        
        shareImageView.image = UIImage(named: "share")
        shareImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(shareImageView)
        shareImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        shareImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        shareImageView.centerYAnchor.constraint(equalTo: (cell.centerYAnchor), constant: -1).isActive = true
        shareImageView.trailingAnchor.constraint(equalTo: labelRating.leadingAnchor, constant: 0).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            performSegue(withIdentifier: "mapSegue", sender: self)
        }
        
        if (restaurant?.isVisited)! && indexPath.row == 6 || !(restaurant?.isVisited)! && indexPath.row == 6 {
            let shareText = "Взгляни на это заведение " + "\u{1F37D} \n" +
                "«\(String(describing: self.restaurant?.name!))»" +
            ""
            if let image = UIImage(named: "fillStar") {
                let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
                present(vc, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let previousRest = self.restaurant
        if segue.identifier == "mapSegue" {
            let dvc = segue.destination as! MapViewController
            dvc.restaurant = self.restaurant
        }
        else if segue.identifier == "editRest"
        {
            let dvc2 = segue.destination as! NewEateryTableViewController
            dvc2.restaraunt = self.restaurant
        }
        
        //            dvc2.lalal = self.restaurant?.type
        //            dvc2.lalal = self.restaurant?.type
        
    }
}

extension UITableViewCell {
    
    var isSeparatorHidden: Bool {
        get {
            return self.separatorInset.right != 0
        }
        set {
            if newValue {
                self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
            } else {
                self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
}
