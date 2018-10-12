import UIKit

class EateriesTableViewCell: UITableViewCell {

  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var viewInCell: UIView!
    
    @IBOutlet weak var checkImage: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
//        let margins = UIEdgeInsets(top: 15, left: 15, bottom: -15, right: -15)
//
//        contentView.frame.inset(by: margins)
//        contentView.layer.cornerRadius = 10
//        contentView.clipsToBounds = false
        viewInCell.layer.borderWidth = 2
        viewInCell.layer.borderColor = UIColor.lightGray.cgColor
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
