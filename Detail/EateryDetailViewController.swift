import UIKit
import PCLBlurEffectAlert


class EateryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var rateButton: UIButton!

    var restaurant: Restaurant?
    
    @IBOutlet weak var starBtn: UIButton!
    var toggleFavouriteButton: Bool!
    
    
    @IBAction func starBtnAction(_ sender: UIButton) {
        if toggleFavouriteButton {
            starBtn.setImage(UIImage(named: "star1"), for: .normal)
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            sender.transform = CGAffineTransform.identity
            },
                           completion: { Void in()  }
            )
            let alert = PCLBlurEffectAlert.Controller(title: "В избранном " + "\u{2B50}", message: "Заведение было добавлено в раздел избранное", effect: UIBlurEffect(style: .prominent), style: .alert)
            let alertAction = PCLBlurEffectAlert.Action(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            alert.configure(cornerRadius: 20)
            alert.configure(overlayBackgroundColor: #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 0.6815603596))
            alert.configure(titleFont: UIFont(name: "HelveticaNeue", size: 20)!, titleColor: .black)
            alert.configure(buttonFont: [PCLBlurEffectAlert.ActionStyle.default : UIFont(name: "HelveticaNeue", size: 16)!])
            alert.configure(backgroundColor: #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 0.7550299658))
            alert.configure(buttonBackgroundColor: #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 0.7550299658))
            
            alert.show()
            //            let timeAfter = DispatchTime.now() + 3
            //            DispatchQueue.main.asyncAfter(deadline: timeAfter){
            //                alert.dismiss(animated: true, completion: nil)
            //            }
            toggleFavouriteButton = !toggleFavouriteButton
        }
        else {
            starBtn.setImage(UIImage(named: "star"), for: .normal)
            toggleFavouriteButton = !toggleFavouriteButton
            
        }
    }
    
    //    @IBOutlet weak var favouriteBtn:!
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue)
    {
        guard let sourceVc = segue.source as? RateViewController else {return}
        guard let rating = sourceVc.restRating else {return}
        rateButton.setImage(UIImage(named:rating), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        toggleFavouriteButton = true

        
        imageView.image = UIImage(data: restaurant!.image! as Data)
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = restaurant!.name

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let label = UILabel()
        label.text = restaurant?.name
        label.frame = CGRect(x: 45, y: 5, width: 150, height: 60)
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 19)
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? EateryDetailTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            cell?.keyLabel.backgroundColor = UIColor(patternImage: UIImage(named: "24-hours")!)
//            cell?.keyLabel.text = "Открыто до"
            cell?.valueLabel.text = "10-30"
        case 1:
            cell?.keyLabel.text = "Тип"
            cell?.valueLabel.text = restaurant?.type
        case 2:
            cell?.keyLabel.text = "Адрес"
            cell?.valueLabel.textColor = .blue
            //            cell?.valueLabel.text = "Открыть на карте"
            cell?.valueLabel.text = restaurant?.location
        case 3:
            cell?.keyLabel.text = "Я там был?"
            cell?.valueLabel.text = restaurant!.isVisited ? "Да" : "Нет"
        default:
            break
        }
        
        cell?.backgroundColor = UIColor.clear
        
        return cell!
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            performSegue(withIdentifier: "mapSegue", sender: self)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let cell = sender as? UITableViewCell {
        //            let i = tableView.indexPath(for: cell)!.row
        //            if i == 2 {
        //            print ("dldldl")
        //
        ////                    && segue.identifier == "mapSegue"{
        ////                    let dvc = segue.destination as! MapViewController
        ////                    dvc.restaurant = self.restaurant
        //                }
        //            }
        if let dvc = segue.destination as? MapViewController {
        dvc.restaurant = self.restaurant
    
        }
    }
    
}

extension UITableViewCell {
    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
    }
    
    func FullSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func halfSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0)
    }
}







