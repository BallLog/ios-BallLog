//
//  NickNameViewModel.swift
//  balllog
//
//  Created by 전은혜 on 04/17/25.
//

import Foundation


class NickNameViewModel: ObservableObject {
    @Published var shouldNavigate: Bool = false // 화면 전환 상태
    
    @Published var nickname: String = "" // 닉네임
    
    @Published var nicknameValid: Bool = false // 닉네임 통과 여부
    
    func confirmNickname() {
        nicknameValid = true
    }
    func denyNickname() {
        nicknameValid = false
    }
}
