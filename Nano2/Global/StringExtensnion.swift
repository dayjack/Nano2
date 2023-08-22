//
//  StringExtensnion.swift
//  Nano2
//
//  Created by ChoiYujin on 8/22/23.
//

import Foundation

import Foundation

extension String {
    static func createRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String(
            (0..<length)
                .map { _ in letters.randomElement()! }
        )
    }
}
