//
//  LogAddViewModel.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI
import PhotosUI

class LogAddViewModel: ObservableObject {
    @Published var photoList: [PhotosPickerItem] = []
    @Published var title: String = ""
    @Published var logContent: String = ""
    @Published var myTeam: String = ""
    @Published var myTeamScore: String = ""
    @Published var opposingTeam: String = ""
    @Published var opposingTeamScore: String = ""
    @Published var gameDate: Date? = nil
    @Published var stadium: String = ""
    @Published var showExitConfirmation = false
    
    // 모든 항목이 입력되었는지 확인
    var isFormValid: Bool {
        !title.isEmpty &&
        gameDate != nil &&
        !myTeam.isEmpty &&
        !opposingTeam.isEmpty &&
        !myTeamScore.isEmpty &&
        !opposingTeamScore.isEmpty &&
        !stadium.isEmpty &&
        !logContent.isEmpty
    }
    
    // 하나라도 입력했는지 확인
    var hasAnyInput: Bool {
        !title.isEmpty ||
        gameDate != nil ||
        !myTeam.isEmpty ||
        !opposingTeam.isEmpty ||
        !myTeamScore.isEmpty ||
        !opposingTeamScore.isEmpty ||
        !stadium.isEmpty ||
        !logContent.isEmpty ||
        !photoList.isEmpty
    }
    
    func saveLog() {
        print("저장 처리 로직")
        // 실제 저장 로직 구현
    }
    
    func resetForm() {
        title = ""
        logContent = ""
        myTeam = ""
        myTeamScore = ""
        opposingTeam = ""
        opposingTeamScore = ""
        gameDate = nil
        stadium = ""
        photoList = []
    }
}
