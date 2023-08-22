//
//  ProductDetail.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import SwiftUI

struct ProductDetail: View {
    
    var pid = ""
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @AppStorage("uid") var uid = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            Text(fireStoreViewModel.product.productName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24))
                .bold()
            Color.gray.frame(height: 400)
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
                    await fireStoreViewModel.productBuy(uid: uid, pid: pid)
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
    ProductDetail()
}
