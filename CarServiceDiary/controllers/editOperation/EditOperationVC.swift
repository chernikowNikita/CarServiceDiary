//
//  EditOperationVC.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit

class EditOperationVC: UIViewController {
    
    // MARK: - Public properties
    var viewModel: EditOperationVM!
    
    // MARK: - Private properties
    private var titleField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()

    private var descView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    private var milagePeriodField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    private var priceField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
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
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      titleField.becomeFirstResponder()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(titleField)
        view.addSubview(descView)
        view.addSubview(milagePeriodField)
        view.addSubview(priceField)
        navigationItem.rightBarButtonItem = okButton
        navigationItem.leftBarButtonItem = cancelButton
        makeConstraints()
    }
    
    private func makeConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
            titleField.heightAnchor.constraint(equalToConstant: 30),
            titleField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            guide.trailingAnchor.constraint(equalTo: titleField.trailingAnchor, constant: 8)
         ])
        
        NSLayoutConstraint.activate([
           descView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
           descView.heightAnchor.constraint(equalToConstant: 60),
           descView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
           guide.trailingAnchor.constraint(equalTo: descView.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
           milagePeriodField.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 8),
           milagePeriodField.heightAnchor.constraint(equalToConstant: 30),
           milagePeriodField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
           guide.trailingAnchor.constraint(equalTo: milagePeriodField.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
           priceField.topAnchor.constraint(equalTo: milagePeriodField.bottomAnchor, constant: 8),
           priceField.heightAnchor.constraint(equalToConstant: 30),
           priceField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
           guide.trailingAnchor.constraint(equalTo: priceField.trailingAnchor, constant: 8)
        ])
    }
    
}

extension EditOperationVC: BindableType {
    func bindViewModel() {
        titleField.text = viewModel.operationTitle
        cancelButton.rx.action = viewModel.onCancel
        
        okButton.rx.tap
          .withLatestFrom(titleField.rx.text.orEmpty)
          .bind(to: viewModel.onUpdate.inputs)
          .disposed(by: self.rx.disposeBag)
    }
}

