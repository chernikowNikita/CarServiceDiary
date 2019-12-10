//
//  BindableType.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 06/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit

protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    mutating func bindViewModel(to viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
