//
//  ListColorCell.swift
//  Charging
//
//  Created by haiphan on 27/07/2021.
//

import UIKit

class ListColorCell: UITableViewCell {

    @IBOutlet weak var vColor: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
