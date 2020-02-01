//
//  WeeklyCell.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/6/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import SwipeCellKit

class WeeklyCell: SwipeTableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var rateText: UILabel!
    @IBOutlet weak var hoursText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
