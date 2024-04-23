//
//  ViewController.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 22.04.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var verticalProducts: [ProductDTO] = []
    var horizontalProducts: [ProductDTO] = []
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        setupCollectionView(collectionView)
        collectionView.register(ProductCardCollectionViewCell.self, forCellWithReuseIdentifier: ProductCardCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var verticalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        setupCollectionView(collectionView)
        collectionView.register(ProductCardCollectionViewCell.self, forCellWithReuseIdentifier: ProductCardCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        fetchProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Private Methods
    
    private func UpdateProductQuantity() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                                
                    if let id = result.value(forKey: "id") as? String {
                        if let quantity = result.value(forKey: "quantity") as? Int {
                            if let index = self.verticalProducts.firstIndex(where: { $0.product.id == id }) {
                                self.verticalProducts[index].quantity = quantity
                                print("verticalProduct quantity updated at start")
                            }
                            if let index = horizontalProducts.firstIndex(where: { $0.product.id == id }) {
                                self.horizontalProducts[index].quantity = quantity
                                print("horizontalProduct quantity updated at start")
                            }

                    }
                        
                        
                    }
                                
                }
            }
            

        } catch {
            print("error")
        }

    }
    
    private func fetchProducts() {
        ProductService().fetchProductsHorizontal { result in
            switch result {
            case .success(let productResponse):
                self.horizontalProducts = productResponse
                //
                DispatchQueue.main.async {
                    self.UpdateProductQuantity()
                    self.horizontalCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
        ProductService().fetchProductsVertical { result in
            switch result {
            case .success(let productResponse):
                self.verticalProducts = productResponse
                //
                DispatchQueue.main.async {
                    self.UpdateProductQuantity()
                    self.verticalCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
    

    private func configureViews() {
        title = "Ürünler"
        let cardButton = MiniCartButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cardButton)
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

        
        view.addSubview(horizontalCollectionView)
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        view.addSubview(verticalCollectionView)
        NSLayoutConstraint.activate([
            verticalCollectionView.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 16),
            verticalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            verticalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.horizontalCollectionView {
            return horizontalProducts.count         }
        else {
            return verticalProducts.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.horizontalCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCardCollectionViewCell.identifier, for: indexPath) as? ProductCardCollectionViewCell else {
                return UICollectionViewCell()
            }
            let productDTO = horizontalProducts[indexPath.item]
            cell.configure(productDto: productDTO)
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCardCollectionViewCell.identifier, for: indexPath) as? ProductCardCollectionViewCell else {
                return UICollectionViewCell()
            }
            let productDTO = verticalProducts[indexPath.item]
            cell.configure(productDto: productDTO)
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width - 32
        let cellWidth = (collectionViewWidth - 16 * 2) / 3
        return CGSize(width: cellWidth, height: 190)
    }
}

class ProductCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductCardCollectionViewCell"
    
    private let productCardView = ProductCardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(productDto: ProductDTO) {
        productCardView.priceLabel.text = productDto.product.priceText
        productCardView.attributeLabel.text = productDto.product.attribute
        productCardView.nameLabel.text = productDto.product.name
        productCardView.imageView.image = UIImage(data: productDto.productImage)
        productCardView.quantityLabel.text = "\(productDto.quantity)"
        productCardView.idLabel.text = productDto.product.id
        let quantity = productDto.quantity
        if quantity > 0 {
            productCardView.quantityLabel.isHidden = false
            productCardView.minusButton.isHidden = false
            productCardView.minusButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            productCardView.quantityLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            if quantity > 1 {
                productCardView.minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
                print("minus added start")
            } else {
                productCardView.minusButton.setImage(UIImage(systemName: "xmark.bin"), for: .normal)
            }
        } else {
            productCardView.quantityLabel.isHidden = true
            productCardView.minusButton.isHidden = true
        }
        
        let containerHeight: CGFloat = quantity > 0 ? 96 : 32
        
        // Update stack view height constraint
        productCardView.stepperStackView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }
        
        productCardView.stepperStackView.heightAnchor.constraint(equalToConstant: containerHeight).isActive = true
        
        layoutIfNeeded()
    }
    
    private func setupViews() {
        addSubview(productCardView)
        productCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productCardView.topAnchor.constraint(equalTo: topAnchor),
            productCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productCardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    private func loadImage(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

}

