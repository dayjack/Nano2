//
//  ProductProtocol.swift
//  Nano2
//
//  Created by ChoiYujin on 8/22/23.
//

import Foundation

protocol ProductProtocol {
    
    @MainActor
    func fetchProduct(pid: String) async
    
    @MainActor
    func fetchAllProductsDic() async
    
    @MainActor
    func productBuy(uid: String, pid: String) async
}
