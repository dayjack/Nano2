//
//  FireStoreViewModel.swift
//  Nano2
//
//  Created by ChoiYujin on 8/22/23.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

class FireStoreViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var product = AllProduct()
    @Published var allProductsDic: [String: AllProduct] = [:]
    @Published var users: [User] = []
    @Published var user: User = User()
    @Published var pidList: [String] = []
    @Published var userPurchaseList: [Product] = []
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
}

// MARK: - UserProtocol
extension FireStoreViewModel: UserProcotol {
    @MainActor
    func fetchAllUsers() async {
        do {
            users = []
            let querySnapshot = try await db.collection("Users").getDocuments()
            for document in querySnapshot.documents {
                let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                let user = try decoder.decode(User.self, from: jsonData)
                users.append(user)
            }
            Log("\(self.users)")
        } catch {
            Log("\(error)")
        }
    }
    
    @MainActor
    func fetchUser(uid: String) async {
        do {
            
            let docRef = try await db.collection("Users").document(uid).getDocument()
            let jsonData = try JSONSerialization.data(withJSONObject: docRef.data() ?? [:])
            let data = try decoder.decode(User.self, from: jsonData)
            user = data
            Log("\(user)")
        } catch {
            Log("\(error)")
        }
    }
    
    @MainActor
    func addNewUser(user: User, uid: String, completion: @escaping () -> Void) async {
        
        let data = [
            "id": user.id,
            "address": user.address,
            "email": user.email,
            "grade": user.grade,
            "nickname": user.nickname,
            "password": user.password,
            "point": user.point
        ] as [String: Any]
        
        do {
            try await db.collection("Users").document(uid).setData(data)
            Log("Successfully written!")
            completion()
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func checkSignIn(uid: String, userInput: User, completion: @escaping () -> Void) async {
        do {
            let docRef = try await db.collection("Users").document(uid).getDocument()
            
            let jsonData = try JSONSerialization.data(withJSONObject: docRef.data() ?? [:])
            let data = try decoder.decode(User.self, from: jsonData)
            user = data
            if userInput.id == user.id && userInput.password == user.password {
                Log("SignIn Success!")
                completion ()
            }
        } catch {
            Log("\(error)")
        }
    }
    
    @MainActor
    func fetchPurchaseList(uid: String) async {
        do {
            pidList = []
            let querySnapshot = try await db.collection("Users").document(uid).collection("purchase").getDocuments()
            for document in querySnapshot.documents {
                self.pidList.append(document.documentID)
            }
            Log("\(self.pidList)")
        } catch {
            Log("\(error)")
        }
    }
    
    @MainActor
    func fetchUserPurchaseList(uid: String) async {
        do {
            userPurchaseList = []
            let querySnapshot = try await db.collection("Users").document(uid).collection("purchase").getDocuments()
            for document in querySnapshot.documents {
                let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                let data = try decoder.decode(Product.self, from: jsonData)
                self.userPurchaseList.append(data)
                Log("\(data.productName)")
            
            }
            Log("\(self.userPurchaseList)")
        } catch {
            Log("\(error)")
        }
    }
}


// MARK: - ProductProtocol
extension FireStoreViewModel: ProductProtocol {
    @MainActor
    func fetchProduct(pid: String) async {
        do {
            
            let docRef = try await db.collection("AllProducts").document(pid).getDocument()
            let jsonData = try JSONSerialization.data(withJSONObject: docRef.data() ?? [:])
            let data = try decoder.decode(AllProduct.self, from: jsonData)
            product = data
            Log("\(product)")
        } catch {
            Log("\(error)")
        }
    }
    
    @MainActor
    func fetchAllProductsDic() async {
        do {
            allProductsDic = [:]
            let querySnapshot = try await db.collection("AllProducts").getDocuments()
            for document in querySnapshot.documents {
                let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                let jsonKey = document.documentID
                let allProduct = try decoder.decode(AllProduct.self, from: jsonData)
                self.allProductsDic[jsonKey] = allProduct
            }
            Log("\(self.allProductsDic)")
        } catch {
            Log("\(error)")
        }
    }
    
    @MainActor
    func productBuy(uid: String, pid: String) async {
        Task {
            await fetchUser(uid: uid)
            
            let docRef = try await db.collection("AllProducts").document(pid).getDocument()
            let jsonData = try JSONSerialization.data(withJSONObject: docRef.data() ?? [:])
            let data = try decoder.decode(AllProduct.self, from: jsonData)
            
            let batch = db.batch()
            
            let userProductRef = db.collection("Users").document(uid).collection("purchase").document(String.createRandomString(length: 10))
            let productRef = db.collection("AllProducts").document(pid)
            let userRef = db.collection("Users").document(uid)
            
            batch.setData([
                "deliveryStatus" : "delivering",
                "pid" : pid,
                "productName" : data.productName,
                "sellStatus" : true
            ], forDocument: userProductRef)
            
            batch.updateData(["productLeft" : data.productLeft - 1], forDocument: productRef)
            batch.updateData(["point" : user.point + data.price / 10], forDocument: userRef)
            
            do {
                try await batch.commit()
                Log("Batch write succeeded.")
            } catch {
                Log(error)
            }
        }
    }
}
