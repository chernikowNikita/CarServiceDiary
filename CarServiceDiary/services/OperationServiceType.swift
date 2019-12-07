//
//  OperationServiceType.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 06/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum OperationServiceError: Error {
    case creationFailed
    case updateFailed(Operation)
    case deletionFailed(Operation)
    case toggleFailed(Operation)
}

protocol OperationServiceType {
    
    @discardableResult
    func createOperation(title: String, desc: String, milagePeriod: Int, price: Int) -> Observable<Operation>
    
    @discardableResult
    func delete(operation: Operation) -> Observable<Void>
    
    @discardableResult
    func update(operation: Operation, editData: EditOperationData) -> Observable<Operation>
    
    @discardableResult
    func complete(operation: Operation, carMilage: Int) -> Observable<Operation>
    
    func operations() -> Observable<Results<Operation>>
    
}
