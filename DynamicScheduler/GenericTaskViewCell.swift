//
//  GenericTaskViewCell.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/4/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit

class GenericTaskViewCell: UITableViewCell {
    
    static let reuseIdentifier = "GenericTaskCell"
    
    @IBOutlet weak var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
