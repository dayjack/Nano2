//
//  User.swift
//  Nano2
//
//  Created by ChoiYujin on 8/18/23.
//

import Foundation

class User: ObservableObject, Codable {
    
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""
    @Published var point: Int = 0
    
    init(address: String = "", email: String = "", nickname: String = "", point: Int = 0) {
        self.address = address
        self.email = email
        self.nickname = nickname
        self.point = point
    }
    
    enum CodingKeys: CodingKey {

        case address
        case email
        case nickname
        case point
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(email, forKey: .email)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(point, forKey: .point)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        address = try container.decode(String.self, forKey: .address)
        email = try container.decode(String.self, forKey: .email)
        nickname = try container.decode(String.self, forKey: .nickname)
        point = try container.decode(Int.self, forKey: .point)
    }
}

