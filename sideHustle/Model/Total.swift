//
//  Total.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/2/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation
import RealmSwift

class Total: Object {
    @objc dynamic var totalName : String = ""
    let days = List<Weekly>()
    
}
