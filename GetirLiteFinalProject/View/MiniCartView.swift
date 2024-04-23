//
//  MiniCartView.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 22.04.2024.
//

import UIKit

class MiniCartButton: UIButton {

    var cornerRadius: CGFloat = 8 {
        didSet {
            layer.cornerRadius = cornerRadius
            amount.layer.cornerRadius = cornerRadius
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
    var amountText: String? {
        didSet {
            amountLabel.text = amountText
        }
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cartLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let amount: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 250/255, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = cornerRadius
        
        addSubview(iconImageView)
        addSubview(amount)
        amount.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 34),
            iconImageView.heightAnchor.constraint(equalToConstant: 34),
            
            amount.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            amount.topAnchor.constraint(equalTo: topAnchor),
            amount.trailingAnchor.constraint(equalTo: trailingAnchor),
            amount.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            amountLabel.centerXAnchor.constraint(equalTo: amount.centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: amount.centerYAnchor)
        ])
    }
}
