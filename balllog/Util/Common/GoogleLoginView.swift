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
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        GoogleSignInButton(style: .standard, action: authViewModel.handleGoogleLogin)
            
    }
}

#Preview {
    GoogleLoginView()
}
