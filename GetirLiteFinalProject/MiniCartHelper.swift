//
//  MiniCartHelper.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 23.04.2024.
//

import Foundation
import UIKit
import CoreData

func UpdateCart() -> MiniCartView {
    let cartButton = MiniCartView()
    var totalCart: Double = Double()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
    fetchRequest.returnsObjectsAsFaults = false
    
    do {
        let results = try context.fetch(fetchRequest)
        if results.count > 0 {
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

    } catch {
        print("error")
    }
    let totalCartString = String(format: "%.2f",totalCart)
    let totalCartWithComma = totalCartString.replacingOccurrences(of: ".", with: ",")
    cartButton.label.text = "₺\(totalCartWithComma)"
    return cartButton
}
