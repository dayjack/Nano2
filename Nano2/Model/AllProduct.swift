//
//  AllProduct.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import Foundation

class AllProduct: ObservableObject, Codable {
    
    let uid = UUID()
    @Published var imageUrl = ""
    @Published var price = 0
    @Published var productDetail = ""
    @Published var productLeft = 0
    @Published var productName = ""
    @Published var providerUID = ""
    
    init() {
        
    }
    
    init(imageUrl: String = "", price: Int = 0, productDetail: String = "", productLeft: Int = 0, productName: String = "", providerUID: String = "") {
        self.imageUrl = imageUrl
        self.price = price
        self.productDetail = productDetail
        self.productLeft = productLeft
        self.productName = productName
        self.providerUID = providerUID
    }
 
    
    enum CodingKeys: CodingKey {
        case imageUrl
        case price
        case productDetail
        case productLeft
        case productName
        case providerUID
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(price, forKey: .price)
        try container.encode(productDetail, forKey: .productDetail)
        try container.encode(productLeft, forKey: .productLeft)
        try container.encode(productName, forKey: .productName)
        try container.encode(providerUID, forKey: .providerUID)
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        price = try container.decode(Int.self, forKey: .price)
        productDetail = try container.decode(String.self, forKey: .productDetail)
        productLeft = try container.decode(Int.self, forKey: .productLeft)
        productName = try container.decode(String.self, forKey: .productName)
        providerUID = try container.decode(String.self, forKey: .providerUID)
    }
}

extension AllProduct: Identifiable {
    static func == (lhs: AllProduct, rhs: AllProduct) -> Bool {
        lhs.uid == rhs.uid
    }
}

extension AllProduct: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

