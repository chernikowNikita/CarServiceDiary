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
}
