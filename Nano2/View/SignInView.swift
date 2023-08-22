//
//  ContentView.swift
//  Nano2
//
//  Created by ChoiYujin on 8/17/23.
//

import CryptoKit
import SwiftUI
import _AuthenticationServices_SwiftUI
import FirebaseAuth

struct SignInView: View {
    
    @State var goTab = false
    @StateObject var appleLoginViewModel = AppleLoginViewModel()
    @StateObject var fireStoreViewModel: FireStoreViewModel = FireStoreViewModel()
    
    @AppStorage("uid") var uid = ""
    @AppStorage("firebaseuid") var firebaseuid = ""
    @AppStorage("nickname") var nickname = ""
    @AppStorage("email") var email = ""
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.4).ignoresSafeArea()
            VStack {
                Spacer()
                SignInWithAppleButton { (request) in
                    
                    appleLoginViewModel.currentNonce = randomNonceString()
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = sha256(appleLoginViewModel.currentNonce)
                } onCompletion: { (result) in
                    
                    switch result {
                    case .success(let user):
                        Task {
                        
                            guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                Log("error with firebase")
                                return
                            }
                            if let fullName = credential.fullName {
                                self.nickname = "\(fullName)"
                                Log(fullName)
                            }
                            if let email = credential.email {
                                self.email = "\(email)"
                                Log(email)
                            }
                            Log(self.nickname)
                            Log(self.email)
                            Log(credential.user)
                            await appleLoginViewModel.authenticate(credential: credential)
                            self.uid = credential.user
                            self.firebaseuid = appleLoginViewModel.firebaseuid
                            await fireStoreViewModel.addNewUser(user: User(address: "", email: "\(self.email)", nickname: "\(self.nickname)", point: 0), uid: self.firebaseuid) {
                                goTab = true
                            }
                        }
                    case .failure(let error):
                        Log(error.localizedDescription)
                    }
                    
                }
                .frame(width: 200, height: 60)
            }
        }
        .onAppear {
            /*
             .authorized : 해당 ID에 대해 인증이 완료되어있는 상태
             .revoked : 해당 ID의 인증이 취소된 상태
             .notFound : 해당 ID의 인증여부를 알 수 없는 상태(최초 진입 등)
             */
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: self.uid) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    Log("authorized: uid -> \(uid)")
                    DispatchQueue.main.async {
                        goTab = true
                    }
                case .revoked:
                    Log("revoked: uid -> \(uid)")
                case .notFound:
                    Log("notFound: uid -> \(uid)")
                default:
                    break
                }
            }
        }
        .navigationDestination(isPresented: $goTab) {
            TabBarView()
                .environmentObject(fireStoreViewModel)
        }
    }
}

#Preview {
    SignInView()
}


