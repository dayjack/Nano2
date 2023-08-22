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

struct ContentView: View {
    
    @State var goTab = false
    @StateObject var appleLoginViewModel = AppleLoginViewModel()
    @StateObject var fireStoreViewModel: FireStoreViewModel = FireStoreViewModel()
    
    @AppStorage("uid") var uid = ""
    @AppStorage("firebaseuid") var firebaseuid = ""
    
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
                                Log("Full Name: \(fullName.givenName ?? "") \(fullName.familyName ?? "")")
                            }
                            if let email = credential.email {
                                Log("Email: \(email)")
                            }
                            Log(credential.user)
                            await appleLoginViewModel.authenticate(credential: credential)
                            self.uid = credential.user
                            self.firebaseuid = appleLoginViewModel.firebaseuid
                            goTab = true
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
                    // The Apple ID credential is valid.
                    DispatchQueue.main.async {
                        //authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                        goTab = true
                    }
                case .revoked:
                    Log("revoked: uid -> \(uid)")
                case .notFound:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
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
    ContentView()
}

func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}
