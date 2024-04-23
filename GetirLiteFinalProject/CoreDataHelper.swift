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
