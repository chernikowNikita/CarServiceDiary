//
//  EditOperationVM.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import Foundation

struct EditOperationVM {
  let operationService: OperationServiceType
  let sceneCoordinator: SceneCoordinatorType
  
  init(operationService: OperationServiceType, coordinator: SceneCoordinatorType) {
      self.operationService = operationService
      self.sceneCoordinator = coordinator
  }
}
