//
//  OperationTVCell.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 06/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit
import RxSwift
import Action
import RealmSwift

class OperationTVCell: UITableViewCell {
    // MARK: - Private properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.green
        return label
    }()
    
    private let remainingMilageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.green
        let priority = UILayoutPriority(rawValue: 900)
        label.setContentHuggingPriority(priority, for: .horizontal)
        label.setContentHuggingPriority(priority, for: .vertical)
        label.setContentCompressionResistancePriority(priority, for: .horizontal)
        label.setContentCompressionResistancePriority(priority, for: .vertical)
        return label
    }()
    
    private var completeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("Выполнить", for: .normal)
        return button
    }()
    
    private let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: nil)
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with operation: Operation, completeAction: CocoaAction) {
        completeButton.rx.action = completeAction
        operation.rx.observe(String.self, "title")
            .subscribe(onNext: { [weak self] title in
                self?.titleLabel.text = title
            })
            .disposed(by: disposeBag)
        
        operation.rx.observe(Int.self, "price")
            .subscribe(onNext: { [weak self] price in
                self?.priceLabel.text = "\(price ?? 0) руб"
            })
            .disposed(by: disposeBag)
        
    }
    
    override func prepareForReuse() {
        completeButton.rx.action = nil
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    // MARK: - Private methods
    private func setupView() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(remainingMilageLabel)
        self.contentView.addSubview(completeButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        NSLayoutConstraint.activate([
            remainingMilageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: remainingMilageLabel.trailingAnchor, constant: 8),
            remainingMilageLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            remainingMilageLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            completeButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 8),
            completeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
