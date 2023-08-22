//
//  SignUpView.swift
//  Nano2
//
//  Created by ChoiYujin on 8/17/23.
//

import SwiftUI

struct SignUpView: View {
    
    @AppStorage("uid") var uid = ""
    @State var signUpComplete: Bool = false
    @StateObject var user = User()
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    
    var body: some View {
        
        VStack {
            Text("회원가입")
            signTextFieldForm(text: "아이디", placeholder: "아이디 입력", inputText: $user.id)
            signTextFieldForm(text: "비밀번호", placeholder: "비밀번호 입력", inputText: $user.password)
            signTextFieldForm(text: "닉네임", placeholder: "닉네임 입력", inputText: $user.nickname)
            signTextFieldForm(text: "이메일", placeholder: "이메일 입력", inputText: $user.email)
            signTextFieldForm(text: "주소", placeholder: "주소 입력", inputText: $user.address)
            Button {
                Task {
                    if user.isDataEmpty() {
                        return
                    }
                    await fireStoreViewModel.addNewUser(user: self.user, uid: "myuid") {
                        self.uid = "myuid"
                        signUpComplete = true
                    }
                }
            } label: {
                signButton(text: "회원가입 완료")
            }
        }
        .navigationDestination(isPresented: $signUpComplete) {
            TabBarView()
                .environmentObject(fireStoreViewModel)
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(FireStoreViewModel())
}
