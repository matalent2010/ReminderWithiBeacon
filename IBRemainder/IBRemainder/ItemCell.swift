//
//  ItemCellTableViewCell.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/11/16.
//  Copyright (c) 2016 Miguel. All rights reserved.
//

import UIKit

/**
 * Reminder cell class of Reminder Table in main View controller
 *
 */
class ItemCell: UITableViewCell {

// front calendar colored Mark in cell
    @IBOutlet weak var lblLogo: UILabel!
// reminder title label
    @IBOutlet weak var lblReminderItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblLogo.layer.cornerRadius = lblLogo.frame.width/2
        lblLogo.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
