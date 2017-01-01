//
//  storeCellTableViewCell.swift
//  Assignment1
//
//  Created by Vinupriya on 1/1/17.
//  Copyright © 2017 Vinupriya. All rights reserved.
//

import UIKit

class storeCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
