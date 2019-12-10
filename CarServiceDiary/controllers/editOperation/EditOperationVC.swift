//
//  EditOperationVC.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit
import RxSwift

class EditOperationVC: UIViewController {
    
    // MARK: - Public properties
    var viewModel: EditOperationVM!
    
    // MARK: - Private properties
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var titleField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    private var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var descView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    private var milagePeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "Периодичность выполнения"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var milagePeriodField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена (руб)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var priceField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    private var okButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        return button
    }()
    
    private var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      titleField.becomeFirstResponder()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .init(red: 255, green: 255, blue: 255, alpha: 0.9)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleField)
        stackView.addArrangedSubview(descLabel)
        stackView.addArrangedSubview(descView)
        stackView.addArrangedSubview(milagePeriodLabel)
        stackView.addArrangedSubview(milagePeriodField)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(priceField)
        navigationItem.rightBarButtonItems = [okButton, cancelButton]
        makeConstraints()
    }
    
    private func makeConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            guide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            titleField.heightAnchor.constraint(equalToConstant: 30),
            descView.heightAnchor.constraint(equalToConstant: 60),
            milagePeriodField.heightAnchor.constraint(equalToConstant: 30),
            priceField.heightAnchor.constraint(equalToConstant: 30)
         ])
    }
    
}

extension EditOperationVC: BindableType {
    func bindViewModel() {
        titleField.text = viewModel.operationTitle
        descView.text = viewModel.operationDesc
        milagePeriodField.text = "\(viewModel.operationMilagePeriod)"
        priceField.text = "\(viewModel.operationPrice)"
        cancelButton.rx.action = viewModel.onCancel
        
        let milagePeriodObservable = milagePeriodField.rx.text.asObservable()
            .filter { $0 != nil }
            .map { Int($0!) }
        
        let priceObservable = milagePeriodField.rx.text.asObservable()
        .filter { $0 != nil }
        .map { Int($0!) }
        
        let inputsObservable: Observable<EditOperationData> = Observable.combineLatest(titleField.rx.text.asObservable(), descView.rx.text.asObservable(), milagePeriodObservable, priceObservable) { title, desc, milagePeriod, price in
            return (title: title, desc: desc, milagePeriod: milagePeriod, price: price)
        }
        
        
        okButton.rx.tap
          .withLatestFrom(inputsObservable)
          .bind(to: viewModel.onUpdate.inputs)
          .disposed(by: self.rx.disposeBag)
    }
}

