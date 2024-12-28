//
//  ProductsManager.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 28/12/24.
//

import Foundation
import FirebaseFirestore

class ProductsManager {
    static let shared = ProductsManager()
    
    private init() {}
    
    private func fetchProductsFromRemote() async throws -> ProductList {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            throw URLError.init(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let products = try JSONDecoder().decode(ProductList.self, from: data)
        return products
    }
    
    // store in firestore
    private func storeProduct(product: ProductList) async throws {
        let collection = Firestore.firestore().collection("products")
        let _ = try collection.addDocument(from: product)
    }
    
    func fetchProductAndStoreInFirestore() async throws {
        let products = try await fetchProductsFromRemote()
        try await storeProduct(product: products)
    }
    
    func fetchProductsFromFirestore() async throws -> [Product] {
        let snapshot = try await Firestore.firestore().collection("products").getDocuments()
        return snapshot.documents.compactMap { queryDocumentSnapshot in
            try? queryDocumentSnapshot.data(as: Product.self)
        }
    }
}
