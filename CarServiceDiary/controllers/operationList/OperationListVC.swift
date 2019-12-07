//
//  OperationListVC.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import NSObject_Rx

class OperationListVC: UIViewController {
    
    // MARK: - Public properties
    var viewModel: OperationListVM!
    var dataSource: RxTableViewSectionedAnimatedDataSource<OperationSection>!
    
    // MARK: - Private properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private let setMilageBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        
        return button
    }()
    
    private let addOperationBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        configureDataSource()
        
        setEditing(true, animated: false)
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = addOperationBarButton
        navigationItem.leftBarButtonItem = setMilageBarButton
        makeConstraints()
    }
    
    private func makeConstraints() {
        let guide = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            guide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
         ])
    }
    
    private func configureDataSource() {
        OperationTVCell.register(in: tableView)
        dataSource = RxTableViewSectionedAnimatedDataSource(
          configureCell: { [weak self] dataSource, tableView, indexPath, item in
            let cell = OperationTVCell.deque(for: tableView, indexPath: indexPath)
            if let self = self {
                let carMilage = UserDefaults.standard.integer(forKey: UserDefaultKey.carMilage.rawValue)
                cell.configure(with: item, completeAction: self.viewModel.onComplete(operation: item, carMilage: carMilage))
            }
            return cell
          },
          titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].model
          }
        )
        dataSource.canEditRowAtIndexPath = { _,_ in true }
    }
    
}

extension OperationListVC: BindableType {
    
    func bindViewModel() {
        viewModel.sectionedOperations
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)
    }
    
}
