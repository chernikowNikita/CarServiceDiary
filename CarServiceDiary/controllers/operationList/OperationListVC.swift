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
    private let carMilageField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionHeaderHeight = 40
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var addOperationBarButton: UIBarButtonItem = {
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
        view.backgroundColor = .white
        view.addSubview(carMilageField)
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = addOperationBarButton
        makeConstraints()
    }
    
    private func makeConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            carMilageField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            carMilageField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            guide.trailingAnchor.constraint(equalTo: carMilageField.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: carMilageField.bottomAnchor, constant: 16),
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
                let carMilage = try! CarService.shared.carMilage.value()
                cell.configure(with: item, completeAction: self.viewModel.onComplete(operation: item, carMilage: carMilage))
            }
            return cell
          },
          titleForHeaderInSection: { dataSource, index in
            if index >= dataSource.sectionModels.count {
                return nil
            }
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
        tableView.rx.itemDeleted
            .map { [unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! Operation
            }
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: self.rx.disposeBag)
        tableView.rx.itemSelected
            .do(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .map { [unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! Operation
            }
            .bind(to: viewModel.editAction.inputs)
            .disposed(by: self.rx.disposeBag)
        addOperationBarButton.rx.action = viewModel.onCreateTask()
        carMilageField.rx.text
            .filter { $0 != nil }
            .map { $0! }
            .map { Int($0) }
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { carMilage in
                UserDefaults.standard.set(carMilage, forKey: UserDefaultKey.carMilage.rawValue)
            })
            .disposed(by: self.rx.disposeBag)
    }
    
}
