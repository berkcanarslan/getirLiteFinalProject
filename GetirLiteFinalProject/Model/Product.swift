//
//  Product.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 22.04.2024.
//

import Foundation
import UIKit

// MARK: - ProductResponseElement
struct ProductResponseElement: Codable {
    let id: String
    let name: String?
    let productCount: Int?
    var products: [Product]?
    let email, password: String?
}

// MARK: - Product
struct Product: Codable {
    let id: String
    let name: String
    let attribute: String?
    let thumbnailURL: String?
    let imageURL: String?
    let price: Double
    let priceText: String
    let shortDescription: String?
    let category: String?
    let unitPrice: Double?
    let squareThumbnailURL: String?
    let status: Int?
    }

struct ProductDTO {
    let product: Product
    let productImage: Data
    var quantity = 0
}

typealias ProductResponse = [ProductResponseElement]

