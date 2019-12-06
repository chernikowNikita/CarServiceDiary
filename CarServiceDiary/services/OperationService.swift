//
//  OperationService.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 06/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct OperationService: OperationServiceType {

    private func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let error {
            print("Failed \(operation) realm with error: \(error)")
            return nil
        }
    }

    @discardableResult
    func createTask(title: String,
                    desc: String,
                    milagePeriod: Int,
                    price: Int?) -> Observable<Operation> {
        let result = withRealm("creating") { realm -> Observable<Operation> in
            let operation = Operation()
            operation.title = title
            operation.desc = desc
            operation.milagePeriod = milagePeriod
            operation.price.value = price
            try realm.write {
                operation.id = (realm.objects(Operation.self).max(ofProperty: "id") ?? 0) + 1
                realm.add(operation)
            }
            return .just(operation)
        }
        return result ?? .error(OperationServiceError.creationFailed)
    }
    
    @discardableResult
    func delete(operation: Operation) -> Observable<Void> {
        let result = withRealm("deleting") { realm -> Observable<Void> in
            try realm.write {
                realm.delete(operation)
            }
            return .empty()
        }
        return result ?? .error(OperationServiceError.deletionFailed(operation))
    }
    
    @discardableResult
    func update(operation: Operation,
                newTitle: String? = nil,
                newDesc: String? = nil,
                newMilagePeriod: Int? = nil,
                newPrice: Int? = nil) -> Observable<Operation> {
        let result = withRealm("updating title") { realm -> Observable<Operation> in
            try realm.write {
                if let title = newTitle {
                    operation.title = title
                }
                if let desc = newDesc {
                    operation.desc = desc
                }
                if let milagePeriod = newMilagePeriod {
                    operation.milagePeriod = milagePeriod
                }
                if let price = newPrice {
                    operation.price.value = price
                }
            }
            return .just(operation)
        }
        return result ?? .error(OperationServiceError.updateFailed(operation))
    }
    
    @discardableResult
    func complete(operation: Operation, in milage: Int) -> Observable<Operation> {
        let result = withRealm("toggling") { realm -> Observable<Operation> in
            try realm.write {
                operation.lastCompletedMilage = milage
            }
            return .just(operation)
        }
        return result ?? .error(OperationServiceError.toggleFailed(operation))
    }
    
    func operations() -> Observable<Results<Operation>> {
        let result = withRealm("getting operations") { realm -> Observable<Results<Operation>> in
            let operations = realm.objects(Operation.self)
            return Observable.collection(from: operations)
        }
        return result ?? .empty()
    }
    
}
