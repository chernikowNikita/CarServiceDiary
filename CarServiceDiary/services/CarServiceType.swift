//
//  CarServiceType.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 06/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation
import RxSwift

protocol CarServiceType {
    var carMilage: BehaviorSubject<Int> { get }
}
