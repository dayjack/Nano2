//
//  Product.swift
//  Nano2
//
//  Created by ChoiYujin on 8/18/23.
//

import Foundation

class Product: ObservableObject, Codable {
    
    let uid = UUID()
    @Published var deliveryStatus: String = ""
    @Published var pid: String  = ""
    @Published var sellStatus: Bool = false
    @Published var productName: String = ""
    
    init() {
        
    }
    
    enum CodingKeys: CodingKey {
        case deliveryStatus
        case pid
        case sellStatus
        case productName
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deliveryStatus, forKey: .deliveryStatus)
        try container.encode(pid, forKey: .pid)
        try container.encode(sellStatus, forKey: .sellStatus)
        try container.encode(productName, forKey: .productName)
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deliveryStatus = try container.decode(String.self, forKey: .deliveryStatus)
        pid = try container.decode(String.self, forKey: .pid)
        sellStatus = try container.decode(Bool.self, forKey: .sellStatus)
        productName = try container.decode(String.self, forKey: .productName)
    }
}

extension Product: Identifiable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.uid == rhs.uid
    }
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
