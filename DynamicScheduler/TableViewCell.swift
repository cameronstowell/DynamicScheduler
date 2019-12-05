//
//  TableViewCell.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/1/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProjectCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //@IBOutlet var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
