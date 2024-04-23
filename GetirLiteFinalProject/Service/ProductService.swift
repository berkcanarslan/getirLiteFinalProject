//
//  ProductService.swift
//  GetirLiteFinalProject
//
//  Created by Berkcan Arslan on 22.04.2024.
//

import Foundation
import UIKit

import Foundation
import UIKit

enum ProductServiceError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidData
    case decodingError(Error)
}

class ProductService {
    
    func fetchProductsHorizontal(completion: @escaping (Result<[ProductDTO], ProductServiceError>) -> Void) {
        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/suggestedProducts") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let productResponse = try decoder.decode([ProductResponseElement].self, from: data)
                
                var productsWithImages: [ProductDTO] = []
                
                for responseElement in productResponse {
                    for product in responseElement.products! {
                        if var imageURL = product.imageURL {
                            if imageURL.hasPrefix("http://") {
                                imageURL = imageURL.replacingOccurrences(of: "http://", with: "https://")
                            }
                            self.fetchImageData(from: imageURL) { result in
                                switch result {
                                case .success(let imageData):
                                    let productDTO = ProductDTO(product: product, productImage: imageData)
                                    productsWithImages.append(productDTO)
                                    
                                    if productsWithImages.count == responseElement.products!.count {
                                        completion(.success(productsWithImages))
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
                                    print("fail")
                                }
                            }
                        }
                        else if let imageURL = product.squareThumbnailURL {
                            self.fetchImageData(from: imageURL) { result in
                                switch result {
                                case .success(let imageData):
                                    let productDTO = ProductDTO(product: product, productImage: imageData)
                                    productsWithImages.append(productDTO)
                                    
                                    if productsWithImages.count == responseElement.products!.count {
                                        completion(.success(productsWithImages))
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
                                    print("fail")
                                }
                            }
                        }
                    }
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    func fetchProductsVertical(completion: @escaping (Result<[ProductDTO], ProductServiceError>) -> Void) {
        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/products") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let productResponse = try decoder.decode([ProductResponseElement].self, from: data)
                
                var productsWithImages: [ProductDTO] = []
                
                for product in productResponse[0].products! {
                        if var imageURL = product.imageURL {
                            if imageURL.hasPrefix("http://") {
                                imageURL = imageURL.replacingOccurrences(of: "http://", with: "https://")
                            }
                            self.fetchImageData(from: imageURL) { result in
                                switch result {
                                case .success(let imageData):
                                    let productDTO = ProductDTO(product: product, productImage: imageData)
                                    productsWithImages.append(productDTO)
                                    
                                    if productsWithImages.count == productResponse[0].products!.count {
                                        completion(.success(productsWithImages))
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
                                    print("fail")
                                }
                            }
                        }
                        else if let imageURL = product.squareThumbnailURL {
                            self.fetchImageData(from: imageURL) { result in
                                switch result {
                                case .success(let imageData):
                                    let productDTO = ProductDTO(product: product, productImage: imageData)
                                    productsWithImages.append(productDTO)
                                    
                                    if productsWithImages.count == productResponse[0].products!.count {
                                        completion(.success(productsWithImages))
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
                                    print("fail")
                                }
                            }
                        }
                    }
                
            } catch {
                completion(.failure(.decodingError(error)))
                print("error")
            }
        }.resume()
    }


    func fetchImageData(from urlString: String, completion: @escaping (Result<Data, ProductServiceError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
