//
//  StoreCellTableViewCell.swift
//  Assignment1
//
//  Created by Vinupriya on 30/12/16.
//  Copyright © 2017 Vinupriya. All rights reserved.
//

import UIKit

class StoreCellTableViewCell: UITableViewCell {

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
