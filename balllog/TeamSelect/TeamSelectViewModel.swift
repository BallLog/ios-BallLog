//
//  TeamSelectViewModel.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import Foundation
import Combine


@MainActor  // 전체 클래스를 메인 액터로 설정
class TeamSelectViewModel: ObservableObject {
    // team data
    @Published var teamData: [[Team]]

    // 상태 관리
    @Published var shouldNavigate: Bool = false
    @Published var teamConfirm: Bool = false
    @Published var selectedTeam: Team?
    @Published var serverMessage: String?
    @Published var errorMessage: String?
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Common 폴더에 있는 TeamData에서 데이터 가져오기
        self.teamData = TeamData.shared.teams
    }
    
    func changeSelectedTeam(_ value: Team) {
        selectedTeam = value
    }
    
    // ✅ 팀 확인 후 API 호출 및 화면 전환 처리
    func confirmTeam() {
        guard let team = selectedTeam else {
            errorMessage = "팀을 선택해주세요"
            return
        }
        
        postTeamSelection(teamId: team.id)
    }

    // 팀 선택 API 호출 
    func postTeamSelection(teamId: Int) {
        isLoading = true
        
        Task {
            do {
                let response = try await APIUtils.shared.selectTeam(teamId: teamId)
                
                if response.code == "OK" {
                    self.serverMessage = response.message
                    self.teamConfirm = false
                    self.shouldNavigate = true
                    
                    print("팀 선택 완료!")
                    print(response)
                    
                    // 팀 이름 저장
                    UserPreferences.shared.saveTeamName(response.data.kboTeamName)
                } else {
                    self.errorMessage = response.message
                    self.teamConfirm = false
                }
                
                self.isLoading = false
                
            } catch APIError.tokenExpired {
                self.errorMessage = "로그인이 만료되었습니다. 다시 로그인해주세요."
                self.teamConfirm = false
                self.isLoading = false
                // TODO: 로그인 화면으로 이동
                
            } catch {
                self.errorMessage = "에러 발생: \(error.localizedDescription)"
                self.teamConfirm = false
                self.isLoading = false
            }
        }
    }
}
