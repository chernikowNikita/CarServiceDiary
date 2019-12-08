//
//  EditOperationVM.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation
import RxSwift
import Action

typealias EditOperationData = (title: String?, desc: String?, milagePeriod: Int?, price: Int?)

struct EditOperationVM {
  
  let operationTitle: String
  let onUpdate: Action<EditOperationData, Void>!
  let onCancel: CocoaAction!
  let disposeBag = DisposeBag()

  init(operation: Operation, coordinator: SceneCoordinatorType, updateAction: Action<EditOperationData, Void>, cancelAction: CocoaAction? = nil) {
    operationTitle = operation.title
    onUpdate = updateAction
    
    onUpdate.executionObservables
      .take(1)
      .subscribe(onNext: { _ in
        coordinator.pop()
      })
      .disposed(by: disposeBag)
    
    onCancel = CocoaAction {
      if let action = cancelAction {
        action.execute()
      }
      return coordinator.pop()
        .asObservable()
        .map { _ in }
    }
  }
}
