//
//  Product.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 27/12/24.
//

import Foundation
struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]
    let thumbnail: String
}

struct ProductList: Codable {
    let products: [Product]
}
