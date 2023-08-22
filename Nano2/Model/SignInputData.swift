//
//  SignInputData.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import Foundation

class SignInputData: ObservableObject {
    
    @Published var inputId: String = ""
    @Published var inputPassword: String = ""
    @Published var inputNickname: String = ""
    @Published var inputEmail: String = ""
    @Published var inputAddress: String = ""
}
