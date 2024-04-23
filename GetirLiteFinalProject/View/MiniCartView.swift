//
//  MiniCartView.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 22.04.2024.
//

import UIKit

class MiniCartView: UIButton {

    var cornerRadius: CGFloat = 8 {
        didSet {
            layer.cornerRadius = cornerRadius
            amount.layer.cornerRadius = cornerRadius
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            icon.image = iconImage
        }
    }
    
    var amountText: String? {
        didSet {
            label.text = amountText
        }
    }
    
    private let icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cartLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        return imageView
    }()
    private let iconView: UIView = {
        let iconView = UIView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        return iconView
    }()
    
    
    private let amount: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CGFloat(8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.heightAnchor.constraint(equalToConstant: 34).isActive = true
        view.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 250/255, alpha: 1)
        return view
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "₺0,00"
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textAlignment = .center
        label.textColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1)
        return label
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
        translatesAutoresizingMaskIntoConstraints = false
        
        iconView.addSubview(icon)
        self.addSubview(iconView)
        amount.addSubview(label)
        self.addSubview(amount)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            
            amount.leadingAnchor.constraint(equalTo: iconView.trailingAnchor),
            amount.topAnchor.constraint(equalTo: topAnchor),
            amount.trailingAnchor.constraint(equalTo: trailingAnchor),
            amount.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: amount.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: amount.centerYAnchor)
        ])
    }
}
