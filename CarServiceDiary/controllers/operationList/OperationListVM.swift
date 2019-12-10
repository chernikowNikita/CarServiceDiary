//
//  OperationListViewModel.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias OperationSection = AnimatableSectionModel<String, Operation>

struct OperationListVM {
    
    let operationService: OperationServiceType
    let sceneCoordinator: SceneCoordinatorType
    
    init(operationService: OperationServiceType, coordinator: SceneCoordinatorType) {
        self.operationService = operationService
        self.sceneCoordinator = coordinator
    }
    
    lazy var deleteAction: Action<Operation, Void> = { this in
        return Action<Operation, Void>() { operation in
            return this.operationService.delete(operation: operation)
        }
    }(self)
    
    lazy var editAction: Action<Operation, Swift.Never> = { this in
      return Action { operation in
        let editViewModel = EditOperationVM(operation: operation, coordinator: this.sceneCoordinator, updateAction: this.onUpdate(operation: operation))
        return this.sceneCoordinator
              .transition(to: Scene.editOperation(editViewModel), type: .push)
              .asObservable()
      }
    }(self)
    
    var sectionedOperations: Observable<[OperationSection]> {
      get {
        let operationsObservable = operationService.operations()
        let carMilageObservable = CarService.shared.carMilage
        
        return Observable
            .combineLatest(operationsObservable, carMilageObservable) { operations, carMilage in
                let sortBlock: ((Operation, Operation) -> Bool) = { left, right in
                    return left.milageToNextCompletion(carMilage: carMilage) <= right.milageToNextCompletion(carMilage: carMilage)
                }
                
                let urgentOperations = operations
                    .filter { operation in
                        return operation.milageToNextCompletion(carMilage: carMilage) <= 0
                    }
                    .sorted(by: sortBlock)
                
                let in100Operations = operations
                    .filter { operation in
                        let milageToNext = operation.milageToNextCompletion(carMilage: carMilage)
                        return milageToNext > 0 && milageToNext <= 100
                    }
                    .sorted(by: sortBlock)
                    
                let in1000Operations = operations
                    .filter { operation in
                        let milageToNext = operation.milageToNextCompletion(carMilage: carMilage)
                        return milageToNext > 100 && milageToNext <= 1000
                    }
                    .sorted(by: sortBlock)
                
                
                let in5000Operations = operations
                    .filter { operation in
                        let milageToNext = operation.milageToNextCompletion(carMilage: carMilage)
                        return milageToNext > 1000 && milageToNext <= 5000
                    }
                    .sorted(by: sortBlock)
                
                let in10000Operations = operations
                    .filter { operation in
                        let milageToNext = operation.milageToNextCompletion(carMilage: carMilage)
                        return milageToNext > 5000 && milageToNext <= 10000
                    }
                    .sorted(by: sortBlock)
                
                let otherOperations = operations
                    .filter { operation in
                        return operation.milageToNextCompletion(carMilage: carMilage) > 10000
                    }
                    .sorted(by: sortBlock)
                
                var sections: [OperationSection] = []
                if !urgentOperations.isEmpty {
                    let section = OperationSection(model: "Срочно", items: urgentOperations)
                    sections.append(section)
                }
                if !in100Operations.isEmpty {
                    let section = OperationSection(model: "Ближайшие 100 км", items: in100Operations)
                    sections.append(section)
                }
                if !in1000Operations.isEmpty {
                    let section = OperationSection(model: "Ближайшие 1000 км", items: in1000Operations)
                    sections.append(section)
                }
                if !in5000Operations.isEmpty {
                    let section = OperationSection(model: "Ближайшие 5000 км", items: in5000Operations)
                    sections.append(section)
                }
                if !in10000Operations.isEmpty {
                    let section = OperationSection(model: "Ближайшие 10000 км", items: in10000Operations)
                    sections.append(section)
                }
                if !otherOperations.isEmpty {
                    let section = OperationSection(model: "Более 10000 км", items: otherOperations)
                    sections.append(section)
                }
                
                return sections
        }
      }
    }
    
    func onComplete(operation: Operation, carMilage: Int) -> CocoaAction {
        return CocoaAction {
            return self.operationService.complete(operation: operation, carMilage: carMilage) .map { _ in }
        }
    }
    
    func onDelete(operation: Operation) -> CocoaAction {
        return CocoaAction {
            return self.operationService.delete(operation: operation)
        }
    }

    func onUpdate(operation: Operation) -> Action<EditOperationData, Void> {
        return Action { editData in
            return self.operationService.update(operation: operation, editData: editData).map { _ in }
        }
    }
    
    func onCreateTask() -> CocoaAction {
        return CocoaAction() { _ in
            return self.operationService
                .createOperation(title: "", desc: "", milagePeriod: 0, price: 0)
                .flatMap { operation -> Observable<Void> in
                    let editViewModel = EditOperationVM(operation: operation, coordinator: self.sceneCoordinator, updateAction: self.onUpdate(operation: operation), cancelAction: self.onDelete(operation: operation))
                    return self.sceneCoordinator
                        .transition(to: .editOperation(editViewModel), type: .modal)
                        .asObservable()
                        .map {_ in }
            }
        }
    }
    
}



