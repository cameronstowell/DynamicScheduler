//
//  ProjectTaskCell.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/2/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit

class ProjectTaskCell: UITableViewCell {
    
    static let reuseIdentifier = "ProjectTaskCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
