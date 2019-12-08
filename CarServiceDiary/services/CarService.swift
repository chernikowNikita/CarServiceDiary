//
//  CarService.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 06/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation
import RxSwift

class CarService: CarServiceType {
    static let shared = CarService()
    
    var carMilage = BehaviorSubject<Int>(value: UserDefaults.standard.integer(forKey: UserDefaultKey.carMilage.rawValue))
    let disposeBag = DisposeBag()
    
    init() {
        UserDefaults.standard.rx.observe(Int.self, UserDefaultKey.carMilage.rawValue)
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: carMilage)
            .disposed(by: disposeBag)
    }
    
}
