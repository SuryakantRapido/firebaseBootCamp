//
//  ProductListView.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 27/12/24.
//
import SwiftUI

enum ProductCategory: String, CaseIterable {
    case all = "All"
    case beauty = "Beauty"
    case electronics = "Electronics"
    case clothing = "Clothing"
}

enum PriceFilter: String, CaseIterable {
    case highToLow = "High to low"
    case lowToHigh = "Low to high"
    case reset = "Reset"
}

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    func loadProducts(
        filter: ProductCategory? = nil,
        priceFilter: PriceFilter? = nil
    ) async throws {
        self.products = try await ProductsManager.shared.fetchProductsFromFirestore()
    }
}

struct ProductListView: View {
    
    @StateObject private var viewModel = ProductViewModel()
    @State var categoryFilter: ProductCategory? = nil
    @State var priceFilter: PriceFilter? = nil

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.products) { product in
                    ProductRow(product: product)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // Category Filter Button
                    Menu("Category Filter") {
                        ForEach(ProductCategory.allCases, id: \.self) { category in
                            Button(category.rawValue) {
                                categoryFilter = category
                            }
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Price Filter Button
                    Menu("Price Filter") {
                        ForEach(PriceFilter.allCases, id: \.self) { filter in
                            Button(filter.rawValue) {
                                priceFilter = filter
                            }
                        }
                    }
                }
            }
            .task {
                do {
                    try await viewModel.loadProducts(filter: categoryFilter, priceFilter: priceFilter)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ProductListView()
}
