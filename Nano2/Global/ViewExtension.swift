//
//  ViewExtension.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import SwiftUI

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
