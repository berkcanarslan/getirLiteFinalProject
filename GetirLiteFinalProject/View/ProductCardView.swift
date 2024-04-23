//
//  ProductCardView.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 22.04.2024.
//

import UIKit
import CoreData

class ProductCardView: UIView {
    
    // MARK: - Properties
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 242/255, green: 240/255, blue: 250/255, alpha: 1).cgColor // #F2F0FA
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let idLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Open Sans", size: 12)
        label.textAlignment = .center
        label.textColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1) // #191919
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Open Sans", size: 12)
        label.textAlignment = .center
        label.textColor = UIColor(red: 105/255, green: 116/255, blue: 136/255, alpha: 1) // #697488
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 14)
        label.textAlignment = .center
        label.textColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1) // #5D3EBC
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stepperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOffset = CGSize(width: 0, height: 1)
        stackView.layer.shadowRadius = 3
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.cornerRadius = 8
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Open Sans", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1) // #5D3EBC
        label.clipsToBounds = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
        
    private func setupViews() {
        
        

        addSubview(imageView)
        addSubview(priceLabel)
        addSubview(nameLabel)
        addSubview(attributeLabel)
        addSubview(stepperStackView)
        
        stepperStackView.addArrangedSubview(plusButton)
        stepperStackView.addArrangedSubview(quantityLabel)
        stepperStackView.addArrangedSubview(minusButton)
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 103.67),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            attributeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stepperStackView.widthAnchor.constraint(equalToConstant: 32),
            stepperStackView.heightAnchor.constraint(equalToConstant: 32),
            stepperStackView.topAnchor.constraint(equalTo: topAnchor, constant: -8),
            stepperStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
              
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
        

        
    }
    
    @objc private func plusButtonTapped() {
        updateStepperLayout(isIncrease: true)
    }

    @objc private func minusButtonTapped() {
        updateStepperLayout(isIncrease: false)
    }


    
    private func updateStepperLayout(isIncrease: Bool) {
        
        
        guard let oldQuantity = Int(quantityLabel.text ?? "0") else { return }
        var newQuantity = Int()
        
        if isIncrease {
            newQuantity = oldQuantity + 1
        }
        else {
            newQuantity = oldQuantity - 1
        }
        
        quantityLabel.text = "\(newQuantity)"

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Check if its already in cart?
        
        if oldQuantity != 0 && newQuantity != 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
            let idString = idLabel.text
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        result.setValue(newQuantity, forKey: "quantity")
                        try context.save()
                        print("quantity changed")
                    }
                }
            }
            catch {
                print("error")
            }
        }
        
        if oldQuantity != 0 && newQuantity == 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
            let idString = idLabel.text
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        context.delete(result)
                        try context.save()
                        print("Item removed")
                    }
                }
            }
            catch {
                print("error")
            }
        }
        


        
        if newQuantity == 1 && oldQuantity == 0 {
            let newCartItem = NSEntityDescription.insertNewObject(forEntityName: "CartItems", into: context)
            newCartItem.setValue(idLabel.text, forKey: "id")
            newCartItem.setValue(nameLabel.text, forKey: "name")
            newCartItem.setValue(priceLabel.text, forKey: "priceText")
            newCartItem.setValue(attributeLabel.text, forKey: "attribute")
            let data = imageView.image!.jpegData(compressionQuality: 0.5)
            newCartItem.setValue(data, forKey: "imageData")
            newCartItem.setValue(newQuantity, forKey: "quantity")
            
            do {
                try context.save()
                print("Added to cart")
            } catch {
                print("error")
            }
        }
        

        
        
        if newQuantity > 0 {
            quantityLabel.isHidden = false
            minusButton.isHidden = false
            
            if newQuantity > 1 {
                minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
            } else {
                minusButton.setImage(UIImage(systemName: "xmark.bin"), for: .normal)
            }
        } else {
            quantityLabel.isHidden = true
            minusButton.isHidden = true
        }
        
        let containerHeight: CGFloat = newQuantity > 0 ? 96 : 32
        
        // Update stack view height constraint
        stepperStackView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }
        
        stepperStackView.heightAnchor.constraint(equalToConstant: containerHeight).isActive = true
        
        layoutIfNeeded()
    }
}

