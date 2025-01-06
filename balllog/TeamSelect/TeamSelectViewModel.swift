//
//  LoginViewModel.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import Foundation

class TeamSelectViewModel: ObservableObject {
    @Published var shouldNavigate: Bool = false // 화면 전환 상태
    @Published var selectedTeam: String? = ""
    
    init(selectedTeam: String? = "") {
       self.selectedTeam = selectedTeam
   }
    
    func changeSelectedTeam(_ value: String) {
        selectedTeam = value
    }
}
