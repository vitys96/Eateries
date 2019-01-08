import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var leadingConstraintToKeyLabel: NSLayoutConstraint!
    @IBOutlet weak var keyImageView: UIImageView!
    @IBOutlet weak var valueLabel1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
