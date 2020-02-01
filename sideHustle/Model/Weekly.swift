//
//  Weekly.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/2/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation
import RealmSwift

class Weekly: Object {
    @objc dynamic var dayName: String = ""
    @objc dynamic var dayDate: Date?
    @objc dynamic var dayDescription: String = ""
    @objc dynamic var dayOrHourly : Double = 0.0
    @objc dynamic var dayPay : Double = 0.0
    @objc dynamic var dayTotal : Double = 0.0
    @objc dynamic var dayIndex : Int = 0
    var parentMonth = LinkingObjects(fromType: Total.self, property: "days")
}
