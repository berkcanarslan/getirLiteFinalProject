//
//  StepperView.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 22.04.2024.
//

import UIKit

class StepperView: UIView {
    // MARK: - Properties
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black // Adjust tint color as needed
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubview(plusButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 32),
            plusButton.heightAnchor.constraint(equalToConstant: 32),
            plusButton.topAnchor.constraint(equalTo: topAnchor),
            plusButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
