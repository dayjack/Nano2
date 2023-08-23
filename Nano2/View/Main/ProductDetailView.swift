//
//  ProductDetail.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    
    var pid = ""
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @AppStorage("firebaseuid") var firebaseuid = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            Text(fireStoreViewModel.product.productName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24))
                .bold()
            
            KFImage(URL(string: "\(fireStoreViewModel.product.imageUrl)"))
                .placeholder { _ in
                    Color.gray
                }
                .onSuccess { r in //성공
                    Log("King succes: \(r)")
                }
                .onFailure { e in //실패
                    Log("King failure: \(e)")
                }
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .padding(.bottom, 20)
            Text(fireStoreViewModel.product.productDetail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.primary)
                .padding(.bottom, 20)
            Text("\(fireStoreViewModel.product.price)$")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue)
                .font(.system(size: 20))
                .bold()
            Button {
                Task {
                    await fireStoreViewModel.productBuy(uid: firebaseuid, pid: pid)
                    await fireStoreViewModel.fetchAllProductsDic()
                    dismiss()
                }
            } label: {
                signButton(text: "구매하기")
            }
            Spacer()
        }
        .padding()
        .task {
            await fireStoreViewModel.fetchProduct(pid: pid)
        }
    }
}

#Preview {
    ProductDetailView()
        .environmentObject(FireStoreViewModel())
}
