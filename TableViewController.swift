
import UIKit
import PCLBlurEffectAlert

class TableViewController: UITableViewController{
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var Headerview : UIView!
    var NewHeaderLayer : CAShapeLayer!
    var toggleFavourite: Bool!
    
    private let Headerheight : CGFloat = 300
    private let Headercut : CGFloat = 50
    var restaurant: Restaurant?
    
    @IBOutlet weak var starBarBtnItem: UIBarButtonItem!
    
    @IBAction func starBarBtnItemAction(_ sender: UIBarButtonItem) {
        if restaurant?.isFavourite == false {
            
            restaurant?.isFavourite = true
            starBarBtnItem.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.7861729452)
            starBarBtnItem.image = UIImage(named: "starBarBtnItem2")
//
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let popularVC = storyBoard.instantiateViewController(withIdentifier: "PupularRestTableViewController") as! PupularRestTableViewController
//            popularVC.popularRests.append(restaurant!)
            popularVC.tableView.reloadData()
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
//        navigationController?.navigationBar.backgroundColor = .white
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
        self.UpdateView()
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.9608, green: 0.7059, blue: 0.2, alpha: 1)
        imageView.image = UIImage(data: restaurant!.image! as Data)
        
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    func UpdateView() {
        tableView.backgroundColor = UIColor.white
        Headerview = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(Headerview)
        
        NewHeaderLayer = CAShapeLayer()
        NewHeaderLayer.fillColor = UIColor.black.cgColor
        Headerview.layer.mask = NewHeaderLayer
        
        let newheight = Headerheight
        tableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newheight)
        
        self.Setupnewview()
    }
    
    func Setupnewview() {
        let newheight = Headerheight
        var getheaderframe = CGRect(x: 0, y: -newheight, width: tableView.bounds.width, height: Headerheight)
        if tableView.contentOffset.y < newheight
        {
            getheaderframe.origin.y = tableView.contentOffset.y
            getheaderframe.size.height = -tableView.contentOffset.y
        }
        
        Headerview.frame = getheaderframe
        let cutdirection = UIBezierPath()
        cutdirection.move(to: CGPoint(x: 0, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: getheaderframe.height))
        cutdirection.addLine(to: CGPoint(x: 0, y: getheaderframe.height))
        NewHeaderLayer.path = cutdirection.cgPath
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.Setupnewview()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Tableview Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4:
            return 90
        default:
            break
        }
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch restaurant?.isVisited {
        case true:
            return 6
        default:
            break
        }
        return 5
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            cell?.keyImageView.image = UIImage(named: "help")
            cell?.valueLabel1.text = restaurant?.location
        case 1:
            cell?.keyImageView.image = UIImage(named: "type")
            cell?.valueLabel1.text = restaurant?.type
        case 2:
            cell?.keyImageView.image = UIImage(named: "pin")
            cell?.valueLabel1.textColor = .blue
            cell?.valueLabel1.text = "Открыть на карте"
        case 3:
            cell?.keyImageView.image = UIImage(named: "pin")
            cell?.valueLabel1.text = restaurant!.isVisited ? "Да" : "Нет"
        case 4:
            let label = UILabel()
            label.frame = CGRect(x: 20, y: 0, width: 100, height: (cell?.frame.height)!)
            label.text = "Рейтинг"
            cell?.addSubview(label)
            cell?.keyImageView.image = UIImage()
            
            let border = CALayer()
            let width = CGFloat(7.0)
            border.borderColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 0.79)
            border.frame = CGRect(x: 0, y: -3, width: tableView.frame.size.width, height: 10)
            border.borderWidth = width
            cell?.layer.addSublayer(border)
            cell?.layer.masksToBounds = true
            
            cell?.valueLabel1.font = UIFont(name: "Futura-Medium", size: 36)
            
            cell?.valueLabel1.textColor = .orange
            let starLabel = restaurant?.star
            switch starLabel {
            case 1:
                cell?.valueLabel1.text = "\u{2605}"
            case 2:
                cell?.valueLabel1.text = "\u{2605}\u{2605}"
            case 3:
                cell?.valueLabel1.text = "\u{2605}\u{2605}\u{2605}"
            case 4:
                cell?.valueLabel1.text = "\u{2605}\u{2605}\u{2605}\u{2605}"
            case 5:
                cell?.valueLabel1.text = "\u{2605}\u{2605}\u{2605}\u{2605}\u{2605}"
            default:
                break
            }
        case 6:
            cell?.valueLabel1.font = UIFont(name: "Futura-Medium", size: 36)
            cell?.valueLabel1.textColor = .orange
            cell?.valueLabel1.text = "\u{2605}\u{2605}\u{2605}\u{2605}"
            
        default:
            break
        }
        
        cell?.backgroundColor = UIColor.clear
        
        return cell!
    }
}

