//
//  MainView.swift
//  Nano2
//
//  Created by ChoiYujin on 8/17/23.
//

import SwiftUI

struct MainView: View {
    
    @State var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @AppStorage("uid") var uid = ""
    
    var body: some View {
        VStack {
            adBanner()
            Spacer().frame(height: 50)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    ForEach(Array(fireStoreViewModel.allProductsDic.keys), id: \.self) { key in
                        if let product = fireStoreViewModel.allProductsDic[key] {
                            NavigationLink {
                                ProductDetail(pid: key)
                                    .environmentObject(fireStoreViewModel)
                            } label: {
                                productItemView(product: product)
                            }
                            .foregroundColor(.black)
                            .disabled(product.productLeft == 0)
                        }
                    }
                }
            }
            Spacer()
        }
        .task {
            await fireStoreViewModel.fetchAllProductsDic()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(FireStoreViewModel())
}

extension MainView {
    
    @ViewBuilder
    func adBanner() -> some View {
        TabView {
            Color.gray
            Color.blue
            Color.green
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 150)
    }
    
    func productItemView(product: AllProduct) -> some View {
        VStack {
            Color.gray.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 10)
            
            Text("\(product.productName)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
                .foregroundColor(product.productLeft == 0 ? .gray : .black)
                .bold()
            Text("\(product.price)$")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(product.productLeft == 0 ? .gray : .blue)
                .font(.system(size: 20))
                .bold()
            Text("재고 : \(product.productLeft) 개")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 2)
                .foregroundColor(product.productLeft == 0 ? .red : .black)
        }
        .frame(height: 250)
        .padding()
    }
}
