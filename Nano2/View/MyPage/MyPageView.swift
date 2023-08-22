//
//  MyPageView.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    @State var isFirstTab = true
    @AppStorage("uid") var uid = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            profileView(user: fireStoreViewModel.user)
            customTab()
            if isFirstTab {
                shoppingList()
            } else {
                myInfo(user: fireStoreViewModel.user)
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.horizontal)
        .task {
            await fireStoreViewModel.fetchUser(uid: uid)
            await fireStoreViewModel.fetchUserPurchaseList(uid: uid)
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(FireStoreViewModel())
}

extension MyPageView {
    
    @ViewBuilder
    func profileView(user: User) -> some View {
        
        HStack {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(.green.opacity(0.4))
                .padding(.trailing, 30)
            VStack {
                Text("\(user.nickname)")
                Text("\(user.grade)")
                Text("\(user.point) point")
            }
            Spacer()
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
        .background(Color.gray.opacity(0.5))
    }
    
    @ViewBuilder
    func customTab() -> some View {
        HStack(spacing: 0) {
            
            Button {
                isFirstTab = true
            } label: {
                Text("구매 목록")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(isFirstTab ? .blue.opacity(0.3) : .white)
            Button {
                isFirstTab = false
            } label: {
                Text("내 정보")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(!isFirstTab ? .blue.opacity(0.3) : .white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
    
    @ViewBuilder
    func shoppingList() -> some View {
        ScrollView {
            ForEach(fireStoreViewModel.userPurchaseList, id: \.self) { product in
                
                NavigationLink {
                    EmptyView()
                } label: {
                    Color.gray.opacity(0.2)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 3, x: 0, y: 2)
                        .overlay {
                            Text(product.productName)
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func myInfo(user: User) -> some View {
        VStack {
            infoForm(title: "아이디", context: user.id)
            infoForm(title: "이메일", context: user.email)
            infoForm(title: "닉네임", context: user.nickname)
            infoForm(title: "주소", context: user.address)
        }
    }
    
    @ViewBuilder
    func infoForm(title: String, context: String) -> some View {
        HStack {
            Text(title)
                .bold()
            Text(context)
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
