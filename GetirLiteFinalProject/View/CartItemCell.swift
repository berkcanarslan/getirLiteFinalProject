//
//  CartItemCell.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 23.04.2024.
//

import UIKit

class CartItemCell: UICollectionViewCell {
    static let identifier = "CartItemCell"
    
    // UI elements
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let idLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    var stepperValueLabel = UILabel()

    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure cell with cart item data
    func configure(with product: ProductDTO) {
        productImageView.image = UIImage(data: product.productImage)
        nameLabel.text = product.product.name
        attributeLabel.text = product.product.attribute
        priceLabel.text = product.product.priceText
        quantityStepper.value = Double(product.quantity)
        stepperValueLabel.text = String(product.quantity)
        idLabel.text = product.product.id
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    @objc private func stepperValueChanged(sender: UIStepper) {
        let oldQuantity = Int(stepperValueLabel.text!)
        let newQuantity = Int(quantityStepper.value)
        let productId = idLabel.text!
        
        quantityStepper.value = Double(newQuantity)
        stepperValueLabel.text = String(newQuantity)
        UpdateProductQuantityWithId(newQuantity: newQuantity, oldQuantity: oldQuantity!, productId: productId)
        
            }

    
    // Setup UI elements and constraints
    private func setupUI() {
        addSubview(productImageView)
        addSubview(nameLabel)
        addSubview(attributeLabel)
        addSubview(priceLabel)
        addSubview(quantityStepper)
        // Stepper Value Label
        stepperValueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stepperValueLabel)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: quantityStepper.leadingAnchor, constant: -8),
            
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            attributeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: attributeLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            quantityStepper.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            stepperValueLabel.centerYAnchor.constraint(equalTo: quantityStepper
                .centerYAnchor),
            stepperValueLabel.centerXAnchor.constraint(equalTo: quantityStepper.centerXAnchor),

        ])
    }
}

