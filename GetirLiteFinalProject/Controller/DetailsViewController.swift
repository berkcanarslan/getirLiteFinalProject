//
//  DetailsViewController.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 23.04.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    var product = ProductDTO(product: Product(id: "", name: "", attribute: nil, thumbnailURL: nil, imageURL: nil, price: 0, priceText: "", shortDescription: nil, category: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil), productImage: Data())
    var cartButton = MiniCartView()
    let stepper = UIStepper()
    let addToCartButton = UIButton()
    var stepperValueLabel = UILabel()


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Customize the navigation bar
        setupNavigationBar()
        
        view.backgroundColor = .white
        


                // Product Image
                let productImageView = UIImageView()
                productImageView.contentMode = .scaleAspectFit
                productImageView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(productImageView)

                // Product Price
                let priceLabel = UILabel()
                priceLabel.font = UIFont.systemFont(ofSize: 18)
                priceLabel.translatesAutoresizingMaskIntoConstraints = false
                priceLabel.textColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)

                view.addSubview(priceLabel)

                // Product Name
                let nameLabel = UILabel()
                nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(nameLabel)

                // Product Attribute
                let attributeLabel = UILabel()
                attributeLabel.font = UIFont.systemFont(ofSize: 16)
                attributeLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(attributeLabel)

        // Stepper Value Label
        stepperValueLabel.translatesAutoresizingMaskIntoConstraints = false
        stepperValueLabel.text = "\(product.quantity)"
        view.addSubview(stepperValueLabel)

        // Add to Cart Button
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.blue, for: .normal)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addToCartButton)
        stepper.stepValue = 1
        stepper.value = Double(product.quantity)
        
stepper.minimumValue = 0
stepper.translatesAutoresizingMaskIntoConstraints = false
stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        view.addSubview(stepper)
                // Constraints
                NSLayoutConstraint.activate([
                    productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    productImageView.heightAnchor.constraint(equalToConstant: 200),

                    nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
                    nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                    priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                    priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    
                    attributeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
                    attributeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    
                    stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    stepper.topAnchor.constraint(equalTo: attributeLabel.bottomAnchor, constant: 20),

                    addToCartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    addToCartButton.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 20),
                    stepperValueLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
                    stepperValueLabel.centerXAnchor.constraint(equalTo: stepper.centerXAnchor),
                    
                    
                    ])
        
        updateUI()
                    
                // Update UI with product details
        productImageView.image = UIImage(data: product.productImage)
        nameLabel.text = product.product.name
        priceLabel.text = product.product.priceText
        attributeLabel.text = product.product.attribute
                
    }
    func updateUI(){
        if product.quantity > 0 {
            stepper.isHidden = false
            stepperValueLabel.isHidden = false
            addToCartButton.isHidden = true
        } else {
            stepper.isHidden = true
            stepperValueLabel.isHidden = true
            addToCartButton.isHidden = false
        }
        cartButton = UpdateCart()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)


    }
    @objc func stepperValueChanged(_ sender: UIStepper) {
        UpdateProductQuantity(newQuantity: Int(sender.value), productDto: product)
        product.quantity = Int(sender.value)
        stepperValueLabel.text = String(product.quantity)
        updateUI()
        
        if (product.quantity <= 0){
            stepperValueLabel.isHidden = true
        }
    }
    @objc func addToCartButtonTapped() {
        UpdateProductQuantity(newQuantity: 1, productDto: product)
        product.quantity = 1
        updateUI()
        stepperValueLabel.text = String(product.quantity)
    }
    

    private func setupNavigationBar() {
        // Create a custom button for the "X" logo
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.tintColor = .white
        let closeBarButtonItem = UIBarButtonItem(customView: closeButton)

        // Assign the custom button as the left bar button item
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

    }

    @objc private func closeButtonTapped() {
        // Dismiss the details screen when the close button is tapped
        navigationController?.popViewController(animated: true)
    }
}
