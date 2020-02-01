//
//  ButtonDesign.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/30/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ButtonDesign: UIButton {
    override var isHighlighted: Bool{
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.02745098039, green: 0.8352941176, blue: 0.6705882353, alpha: 1) : UIColor(named: "darkModeButton")
        }
    }
}
