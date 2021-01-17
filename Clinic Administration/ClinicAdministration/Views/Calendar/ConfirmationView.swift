//
//  ConfirmationView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 15.12.2020.
//

import UIKit

final class ConfirmationView: UIView {
    
    private let separatorView = UIView()
    private let confirmButton = UIButton()
    private let cancelButton = UIButton()
    private let dateLabel = UILabel()
    
    var dateText: String = " " {
        didSet {
            dateLabel.text = dateText
            setNeedsLayout()
        }
    }
    
    var cancelAction: (() -> Void)?
    var confirmAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Design.Color.white
        
        separatorView.backgroundColor = Design.Color.darkGray
        
        dateLabel.numberOfLines = 2
        dateLabel.font = Design.Font.robotoFont(ofSize: 16, weight: .medium)
        dateLabel.textColor = Design.Color.chocolate
        
        cancelButton.backgroundColor = Design.Color.gray
        cancelButton.setTitle("ОТМЕНИТЬ", for: .normal)
        cancelButton.titleLabel?.font = Design.Font.robotoFont(ofSize: 16, weight: .regular)
        cancelButton.setTitleColor(Design.Color.brown, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Design.Color.chocolate.cgColor
        cancelButton.layer.cornerRadius = Design.CornerRadius.small
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        confirmButton.backgroundColor = Design.Color.red
        confirmButton.setTitle("ГОТОВО", for: .normal)
        confirmButton.titleLabel?.font = Design.Font.robotoFont(ofSize: 16, weight: .regular)
        confirmButton.setTitleColor(Design.Color.white, for: .normal)
        confirmButton.layer.cornerRadius = Design.CornerRadius.small
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        for view in [separatorView, dateLabel, cancelButton, confirmButton] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 16),
            confirmButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            confirmButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancel() {
        cancelAction?()
    }
    
    @objc private func confirm() {
        confirmAction?()
    }
}
