
import UIKit

class PopularRestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var checkImageViewPopular: UIImageView!
    @IBOutlet weak var contentViewInCell: UIView!
    @IBOutlet weak var imageViewPopular: UIImageView!
    @IBOutlet weak var nameLabelPopular: UILabel!
    @IBOutlet weak var locationLabelPopular: UILabel!
    @IBOutlet weak var tyoeLabelPopular: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
