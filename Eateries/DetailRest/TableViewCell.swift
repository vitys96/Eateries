//
//  TableViewCell.swift
//  Eateries
//
//  Created by Виталий Охрименко on 01/10/2018.
//  Copyright © 2018 Ivan Akulov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var leadingConstraintToKeyLabel: NSLayoutConstraint!
    @IBOutlet weak var keyImageView: UIImageView!
    @IBOutlet weak var valueLabel1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
