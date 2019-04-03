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
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        viewInCell.layer.borderWidth = 2
        viewInCell.layer.cornerRadius = 10
        viewInCell.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
