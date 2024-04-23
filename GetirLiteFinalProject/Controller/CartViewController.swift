//
//  CartViewController.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 23.04.2024.
//

import UIKit
import CoreData

class CartViewController: UIViewController {
    
    // MARK: - Properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // Configure collection view properties
        return collectionView
    }()
    var products = [ProductDTO]()
    var totalCartPriceLabel = UILabel()
    var emptyCartLabel: UILabel {
        let label = UILabel()
        label.text = "Sepetiniz boş :)"
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    var completeOrderButton = UIButton(type: .system)

    
    // Add other properties as needed
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyCartLabel)
        
        // Setup UI elements and constraints
        view.backgroundColor = .white
        // Setup navigation bar

        setupNavigationBar()
        
        // Setup cart items
        setupCartItems()
        setupCartItemsCollectionView()
        
        // Setup complete order button and total cart price
        setupCompleteOrderButton()
        UpdateCart()
        NotificationCenter.default.addObserver(self, selector: #selector(ItemRemoved), name: Notification.Name(rawValue: "ItemRemoved"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateCart), name: Notification.Name(rawValue: "CartUpdate"), object: nil)
    }
    
    // MARK: - Private Methods

    @objc func ItemRemoved(){
        setupCartItems()
    }
    @objc func CartUpdate(){
        UpdateCart()
    }
    
    private func setupNavigationBar() {
        // Add close button to the left
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = closeButton
        
        // Add clear cart button to the right
        let clearButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(clearButtonTapped))
        clearButton.tintColor = .white
        navigationItem.rightBarButtonItem = clearButton
    }
    
    @objc func UpdateCart(){
        var totalCart: Double = Double()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                emptyCartLabel.isHidden = true
                completeOrderButton.isEnabled = true
                completeOrderButton.isHidden = false
                totalCartPriceLabel.isHidden = false

                for result in results as! [NSManagedObject] {
                                
                        
                    if let priceText = result.value(forKey: "priceText") as? String {
                        if let quantity = result.value(forKey: "quantity") as? Int {
                            let withoutCurrencySymbol = priceText.replacingOccurrences(of: "₺", with: "")
                            let stringWithDoth = withoutCurrencySymbol.replacingOccurrences(of: ",", with: ".")
                            let price = Double(stringWithDoth) ?? 0.00
                            totalCart = totalCart + price * Double(quantity)
                        }
        
                    }
                        
                    }
                                
                }
            else {
                emptyCartLabel.isHidden = false
                completeOrderButton.isEnabled = false
                completeOrderButton.isHidden = true
                totalCartPriceLabel.isHidden = true
            }

        } catch {
            print("error")
        }
        let totalCartString = String(format: "%.2f",totalCart)
        let totalCartWithComma = totalCartString.replacingOccurrences(of: ".", with: ",")
        totalCartPriceLabel.text = "₺\(totalCartWithComma)"

            }
    
    private func setupCartItemsCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self // No need to specify UICollectionViewDataSource here
        collectionView.delegate = self
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: CartItemCell.identifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupCartItems() {
        getCartProducts { [weak self] cartProducts in
            self?.products = cartProducts
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupCompleteOrderButton() {
        // Create and setup the Complete Order button at the bottom of the screen

        completeOrderButton.setTitle("Siparişi Tamamla", for: .normal)
        completeOrderButton.addTarget(self, action: #selector(completeOrderButtonTapped), for: .touchUpInside)
        completeOrderButton.backgroundColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        completeOrderButton.setTitleColor(.white, for: .normal)
        
        // Add constraints for the button
        
        // Create a stack view to arrange the button and total price label vertically
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(completeOrderButton)
        totalCartPriceLabel.text = "Total: $xxx.xx" // Placeholder text
        totalCartPriceLabel.textAlignment = .center
        stackView.addArrangedSubview(totalCartPriceLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completeOrderButton.widthAnchor.constraint(equalToConstant: 225),

        ])
    }
    
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        // Handle close button tap
        // Dismiss the CartViewController
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearButtonTapped() {
        // Handle clear cart button tap
        // Clear the cart items
        ClearCart()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func completeOrderButtonTapped() {
        // Handle complete order button tap
        // Proceed to complete the order
        let alertController = UIAlertController(title: "Order Success", message: "Your order has been successfully placed.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    ClearCart()
                    self.navigationController?.popViewController(animated: true)
                }))
                present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the cart
        return self.products.count // Replace with the actual count of cart items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else {
            return UICollectionViewCell()
        }
        // Configure the cell with data for the corresponding item in the cart
        // You'll need to pass the cart item data to the cell and update its UI
        cell.configure(with: products[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the size of each item in the collection view
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

