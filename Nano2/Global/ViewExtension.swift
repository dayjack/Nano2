//
//  ViewExtension.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import SwiftUI
import CryptoKit

extension View {
    func signButton(text: String) -> some View {
        Text(text)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.cyan)
            .cornerRadius(10)
            .padding(.horizontal, 30)
            .padding(.vertical)
    }
    
    func signTextFieldForm(text: String, placeholder: String, inputText: Binding<String>) -> some View {
        HStack(spacing: 30) {
            Text(text)
            TextField(placeholder, text: inputText)
                .textFieldStyle(.roundedBorder)
                .frame(height: 60)
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Apple Login
extension View {
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}
