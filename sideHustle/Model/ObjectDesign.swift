//
//  ObjectDesign.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/31/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

struct ObjectDesign {
    
     var button: UIButton
     var segment: UISegmentedControl
     var rate: UITextField
     var description: UITextField
     var hours: UITextField
    
    
    
//    mutating func setDesign(button: UIButton, segment: UISegmentedControl, rate: UITextField, description: UITextField, hours: UITextField){
//        self.button = button
//        self.segment = segment
//        self.rate = rate
//        self.description = description
//        self.hours = hours
//    }
    
    mutating func applyDesign(){
       segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "darkModeText")!], for: .normal)
       segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(named:"darkModeText")!], for: .selected)
       button.layer.cornerRadius = 20.0
       rate.layer.borderWidth = 1
       rate.layer.borderColor = UIColor.black.cgColor
       rate.layer.cornerRadius = 5.0
       description.layer.borderWidth = 1
       description.layer.borderColor = UIColor.black.cgColor
       description.layer.cornerRadius = 5.0
       hours.layer.borderWidth = 1
       hours.layer.borderColor = UIColor.black.cgColor
       hours.layer.cornerRadius = 5.0
    }
    
    
}
