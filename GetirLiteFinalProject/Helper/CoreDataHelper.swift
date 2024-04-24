//
//  CoreDataHelper.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 23.04.2024.
//

import Foundation
import UIKit
import CoreData

func UpdateProductQuantity(newQuantity: Int, productDto: ProductDTO) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let oldQuantity = productDto.quantity
    
    // Check if its already in cart?
    
    if oldQuantity != 0 && newQuantity != 0 {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
        let idString = productDto.product.id
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
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
        let idString = productDto.product.id
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
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
        newCartItem.setValue(productDto.product.id, forKey: "id")
        newCartItem.setValue(productDto.product.name, forKey: "name")
        newCartItem.setValue(productDto.product.priceText, forKey: "priceText")
        newCartItem.setValue(productDto.product.attribute, forKey: "attribute")
        newCartItem.setValue(productDto.productImage, forKey: "imageData")
        newCartItem.setValue(newQuantity, forKey: "quantity")
        
        do {
            try context.save()
            print("Added to cart")
        } catch {
            print("error")
        }
    }
    
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "CartUpdate"), object: nil))
    
}

func getProduct(productDto: ProductDTO, completion: @escaping (ProductDTO) -> Void) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
    let idString = productDto.product.id
    fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
    fetchRequest.returnsObjectsAsFaults = false
    
    do {
        let results = try context.fetch(fetchRequest)
        if results.count > 0 {
            var updatedProductDto = productDto // Create a local copy to modify
            for result in results as! [NSManagedObject] {
                if let imageData = result.value(forKey: "imageData") as? Data {
                    updatedProductDto.productImage = imageData
                }
                // Update other properties of updatedProductDto as needed
                print("product fetched")
            }
            completion(updatedProductDto) // Call completion handler with the modified productDto
        }
    }
    catch {
        print("error")
    }
}
func getCartProducts(completion: @escaping ([ProductDTO]) -> Void) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
    
    do {
        let results = try context.fetch(fetchRequest)
        var cartProducts: [ProductDTO] = []
        
        for result in results as! [NSManagedObject] {
            var productDTO = ProductDTO(product: Product(id: "", name: "", thumbnailURL: nil, imageURL: nil, price: 0, priceText: "", shortDescription: nil, category: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil), productImage: Data())
            
            // Populate productDTO with data from Core Data
            if let id = result.value(forKey: "id") as? String {
                productDTO.product.id = id
            }
            if let name = result.value(forKey: "name") as? String {
                productDTO.product.name = name
            }
            if let priceText = result.value(forKey: "priceText") as? String {
                productDTO.product.priceText = priceText
            }
            if let attribute = result.value(forKey: "attribute") as? String {
                productDTO.product.attribute = attribute
            }
            if let imageData = result.value(forKey: "imageData") as? Data {
                productDTO.productImage = imageData
            }
            if let quantity = result.value(forKey: "quantity") as? Int {
                productDTO.quantity = quantity
            }
            
            cartProducts.append(productDTO)
        }
        
        completion(cartProducts) // Return the cart products array through the completion handler
    } catch {
        print("Error fetching cart products: \(error)")
        completion([]) // Return an empty array in case of an error
    }
}
func UpdateProductQuantityWithId(newQuantity: Int, oldQuantity: Int, productId: String) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    // Check if its already in cart?
    
    if oldQuantity != 0 && newQuantity != 0 {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
        let idString = productId
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
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
            else{
                print("ürün bulunamadı")
                print(idString)
            }
        }
        catch {
            print("error")
        }
    }
    
    if oldQuantity != 0 && newQuantity == 0 {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
        let idString = productId
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                    try context.save()
                    print("Item removed")
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ItemRemoved"), object: nil))
                }
            }
        }
        catch {
            print("error")
        }
    }
    
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "CartUpdate"), object: nil))
    
}
func ClearCart() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
            
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
    fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                    try context.save()
                    print("Item removed")
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ItemRemoved"), object: nil))
                }
            }
        }
        catch {
            print("error")
        }
    
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "CartUpdate"), object: nil))
    
}




