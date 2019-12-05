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
    let price = RealmOptional<Int>()
    
    @objc dynamic var checked: Date? = nil
    
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
