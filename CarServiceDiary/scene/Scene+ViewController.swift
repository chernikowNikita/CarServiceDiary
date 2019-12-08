//
//  Scene+UIViewController.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit

extension Scene {
    
    func viewController(for type: SceneTransitionType) -> UIViewController {
        switch self {
        case .operationList(let viewModel):
            let vc = createOperationListVC(with: viewModel)
            return wrapInNcIfNeeded(vc, for: type)
        case .editOperation(let viewModel):
            let vc = createEditOperationVC(with: viewModel)
            return wrapInNcIfNeeded(vc, for: type)
        }
    }
    
    fileprivate func wrapInNcIfNeeded(_ vc: UIViewController, for type: SceneTransitionType) -> UIViewController {
        if case .push = type {
            return vc
        } else {
            let nc = UINavigationController()
            nc.setViewControllers([vc], animated: true)
            return nc
        }
    }
    
    fileprivate func createOperationListVC(with viewModel: OperationListVM) -> OperationListVC {
        var vc = OperationListVC()
        vc.bindViewModel(to: viewModel)
        return vc
    }
    
    fileprivate func createEditOperationVC(with viewModel: EditOperationVM) -> EditOperationVC {
        var vc = EditOperationVC()
        vc.bindViewModel(to: viewModel)
        return vc
    }
    
}
