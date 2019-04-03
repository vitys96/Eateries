
import UIKit

class PopularRestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        shadowView.layer.shadowOpacity = 6
        shadowView.layer.shadowRadius = 3
//        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 10).cgPath
    }

    @IBOutlet weak var checkImageViewPopular: UIImageView!
    @IBOutlet weak var contentViewInCell: UIView!
    @IBOutlet weak var imageViewPopular: UIImageView!
    @IBOutlet weak var nameLabelPopular: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
