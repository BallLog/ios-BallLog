//
//  GoogleLoginView.swift
//  balllog
//
//  Created by 전은혜 on 10/26/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleLoginView: View {

    func handleSignInButton() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Cannot find root view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
              guard let result = signInResult else {
                // Inspect error
                return
              }
                
            // 로그인 성공 처리
            let user = result.user
            let userId = user.userID                  // 사용자 고유 ID
            let userEmail = user.profile?.email       // 이메일
            let userName = user.profile?.name         // 이름
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)  // 프로필 사진 URL
            
                print("Successfully logged in as \(userName ?? "unknown user")")

            }
    }

    var body: some View {
        GoogleSignInButton(style: .icon, action: handleSignInButton)
            
    }
}

#Preview {
    GoogleLoginView()
}
