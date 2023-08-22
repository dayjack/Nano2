//
//  ContentView.swift
//  Nano2
//
//  Created by ChoiYujin on 8/17/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var goSignUp = false
    @State var goSignIn = false
    
    @StateObject var fireStoreViewModel: FireStoreViewModel = FireStoreViewModel()
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.4).ignoresSafeArea()
            VStack {
                Spacer()
                Button {
                    goSignIn = true
                } label: {
                    signButton(text: "로그인")
                }
                Button {
                    goSignUp = true
                } label: {
                    signButton(text: "회원가입하기")
                }
            }
        }
        .navigationDestination(isPresented: $goSignUp) {
            SignUpView()
                .environmentObject(fireStoreViewModel)
        }
        .navigationDestination(isPresented: $goSignIn) {
            SignInView()
                .environmentObject(fireStoreViewModel)
        }
    }
}

#Preview {
    ContentView()
}
