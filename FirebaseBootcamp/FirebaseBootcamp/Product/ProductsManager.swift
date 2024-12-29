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
    private let collection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        collection.document(productId)
    }
    private init() {}
    
    private func fetchProductsFromRemote() async throws -> ProductList {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            throw URLError.init(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let products = try JSONDecoder().decode(ProductList.self, from: data)
        return products
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id))
              .setData(from: product,
                       merge: false)
    }

    // store in firestore
    private func storeProduct(productList: ProductList) async throws {
        for product in productList.products {
            try await uploadProduct(product: product)
        }
    }
    
    func fetchProductAndStoreInFirestore() async throws {
        let products = try await fetchProductsFromRemote()
        try await storeProduct(productList: products)
    }
    
    private func fetchProductsAll() async throws ->  [Product] {
        let query = collection
        let snapshot = try await query.getDocuments()
        return try snapshot
               .documents
               .compactMap { try $0.data(as: Product.self) }
    }
    
    private func fetchProducts(category: ProductCategory) async throws ->  [Product] {
        let query = collection.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category.rawValue)
        let snapshot = try await query.getDocuments()
        return try snapshot
               .documents
               .compactMap { try $0.data(as: Product.self) }
    }
    
    private func fetchProducts(priceFilter: PriceFilter) async throws ->  [Product] {
        let snapshot = try await collection
            .order(by: Product.CodingKeys.price.rawValue,
                   descending: priceFilter.decending)
            .getDocuments()
        return try snapshot
               .documents
               .compactMap { try $0.data(as: Product.self) }
    }
    
    private func fetchProductsWithFilters(
        filter: ProductCategory,
        priceFilter: PriceFilter
    ) async throws -> ProductList {
        let snapShot: QuerySnapshot =  try await collection
            .order(by: Product.CodingKeys.price.rawValue, descending: priceFilter.decending)
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: filter.rawValue)
            .getDocuments()
        let products = try snapShot.documents.compactMap { try $0.data(as: Product.self) }
        
        return ProductList(products: products)
    }
    
    func fetchProducts(
        filter: ProductCategory? = nil,
        priceFilter: PriceFilter? = nil
    ) async throws -> ProductList {
        if let filter = filter, let priceFilter = priceFilter {
            return try await fetchProductsWithFilters(filter: filter, priceFilter: priceFilter)
        } else if let filter = filter {
            return try await ProductList(products: fetchProducts(category: filter))
        } else if let priceFilter = priceFilter {
            return try await fetchProducts(priceFilter: priceFilter)
        } else {
            return try await ProductList(products: fetchProductsAll())
        }
    }
}


extension Query {
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (products, snapshot.documents.last)
    }
}
