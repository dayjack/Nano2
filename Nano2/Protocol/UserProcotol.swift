//
//  UserProcotol.swift
//  Nano2
//
//  Created by ChoiYujin on 8/22/23.
//

import Foundation

protocol UserProcotol {
    
    @MainActor
    func fetchAllUsers() async
    
    @MainActor
    func fetchUser(uid: String) async
    
    @MainActor
    func addNewUser(user: User, uid: String, completion: @escaping () -> Void) async
    
    @MainActor
    func checkSignIn(uid: String, userInput: User, completion: @escaping () -> Void) async
    
    @MainActor
    func fetchPurchaseList(uid: String) async
    
    @MainActor
    func fetchUserPurchaseList(uid: String) async
}
