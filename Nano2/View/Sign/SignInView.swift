//
//  SignInView.swift
//  Nano2
//
//  Created by ChoiYujin on 8/21/23.
//

import SwiftUI

struct SignInView: View {
    
    @State var goMain = false
    
    @StateObject var inputUser = User()
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @AppStorage("uid") var uid = ""
    
    var body: some View {
        VStack {
            signTextFieldForm(text: "아이디", placeholder: "아이디 입력", inputText: $inputUser.id)
            signTextFieldForm(text: "비밀번호", placeholder: "비밀번호 입력", inputText: $inputUser.password)
            Button {
                Task {
                    await fireStoreViewModel.checkSignIn(uid: uid, userInput: inputUser) {
                        goMain = true
                    }
                }
            } label: {
                signButton(text: "로그인")
            }
        }
        .navigationDestination(isPresented: $goMain) {
            TabBarView()
                .environmentObject(fireStoreViewModel)
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(FireStoreViewModel())
}
