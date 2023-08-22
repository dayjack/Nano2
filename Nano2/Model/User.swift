//
//  User.swift
//  Nano2
//
//  Created by ChoiYujin on 8/18/23.
//

import Foundation

class User: ObservableObject, Codable {
    
    @Published var id: String = ""
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""
    @Published var password: String = ""
    @Published var point: Int = 0
    @Published var grade: String = ""
    
    init(id: String = "", address: String = "", email: String = "", nickname: String = "", password: String = "", point: Int = 0, grade: String = "") {
        self.id = id
        self.address = address
        self.email = email
        self.nickname = nickname
        self.password = password
        self.point = point
        self.grade = grade
    }
    
    enum CodingKeys: CodingKey {
        case id
        case address
        case email
        case nickname
        case password
        case point
        case grade
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(address, forKey: .address)
        try container.encode(email, forKey: .email)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(password, forKey: .password)
        try container.encode(point, forKey: .point)
        try container.encode(grade, forKey: .grade)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        address = try container.decode(String.self, forKey: .address)
        email = try container.decode(String.self, forKey: .email)
        nickname = try container.decode(String.self, forKey: .nickname)
        password = try container.decode(String.self, forKey: .password)
        point = try container.decode(Int.self, forKey: .point)
        grade = try container.decode(String.self, forKey: .grade)
    }
    
    func isDataEmpty() -> Bool {
        return id == "" || address == "" || email == "" || nickname == "" || password == ""
    }
}

