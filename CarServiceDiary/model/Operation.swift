//
//  Operation.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class Operation: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var milagePeriod: Int = 0
    @objc dynamic var lastCompletedMilage: Int = 0
    @objc dynamic var price: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Operation: IdentifiableType {
    var identity: Int {
        get {
            return self.isInvalidated ? 0 : id
        }
    }
}

// MARK: - Calculate Milage
extension Operation {
    func milageFromLastComplete(carMilage: Int) -> Int {
        return carMilage - self.lastCompletedMilage
    }

    func milageToNextCompletion(carMilage: Int) -> Int {
        return self.milagePeriod - self.milageFromLastComplete(carMilage: carMilage)
    }
}
