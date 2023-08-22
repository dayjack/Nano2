//
//  TabBarView.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    var body: some View {
        TabView {
            MainView()
                .environmentObject(fireStoreViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("상점")
                }

            MyPageView()
                .environmentObject(fireStoreViewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("내 정보")
                }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TabBarView()
        .environmentObject(FireStoreViewModel())
}
