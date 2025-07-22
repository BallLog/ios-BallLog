//
//  TeamSelectViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import Foundation
import Combine

class TeamSelectViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var teamData: [[Team]] = []
    @Published var selectedTeam: Team?
    @Published var shouldNavigate: Bool = false
    @Published var teamConfirm: Bool = false
    @Published var serverMessage: String?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    // MARK: - Private Properties
    private let teamSelectionService: TeamSelectionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    static let teams: [[Team]] = [
       [Team(id: 1, name: "삼성 라이온즈"), Team(id: 3, name: "롯데 자이언츠")],
       [Team(id: 9, name: "SSG 랜더스"), Team(id: 2, name: "KIA 타이거즈")],
       [Team(id: 4, name: "LG 트윈스"), Team(id: 6, name: "두산 베어스")],
       [Team(id: 5, name: "한화 이글스"), Team(id: 10, name: "키움 히어로즈")],
       [Team(id: 7, name: "KT 위즈"), Team(id: 8, name: "NC 다이노스")]
   ]
   
    // MARK: - Static Stadium Data
    static let stadiums: [Stadium] = [
        Stadium(id: 1, name: "광주-기아 챔피언스 필드"),
        Stadium(id: 2, name: "대구 삼성 라이온즈 파크"),
        Stadium(id: 3, name: "서울 종합운동장 야구장"),
        Stadium(id: 4, name: "수원 케이티 위즈 파크"),
        Stadium(id: 5, name: "사직 야구장"),
        Stadium(id: 6, name: "대전 한화생명 볼파크"),
        Stadium(id: 7, name: "고척 스카이돔"),
        Stadium(id: 8, name: "창원 NC 파크"),
        Stadium(id: 9, name: "인천 SSG 랜더스 필드")
    ]
    
    // 모든 팀을 1차원 배열로 변환 (ID로 팀 찾기용)
    static let allTeams: [Team] = teams.flatMap { $0 }
    
    // MARK: - Static Helper Methods
    static func findTeamById(_ id: Int) -> Team? {
        return allTeams.first { $0.id == id }
    }
    
    static func findTeamByName(_ name: String) -> Team? {
        return allTeams.first { $0.name == name }
    }
    
    // MARK: - Static Stadium Helper Methods
    static func findStadiumById(_ id: Int) -> Stadium? {
        return stadiums.first { $0.id == id }
    }
    
    static func findStadiumByName(_ name: String) -> Stadium? {
        return stadiums.first { $0.name == name }
    }
    
    static func getStadiumName(by id: Int) -> String {
        return findStadiumById(id)?.name ?? "경기장 정보 없음"
    }
    
    static func getStadiumId(by name: String) -> Int? {
        return findStadiumByName(name)?.id
    }
    
    static func getAllStadiumNames() -> [String] {
        return stadiums.map { $0.name }
    }

    // MARK: - Initialization
    init(teamSelectionService: TeamSelectionServiceProtocol = TeamSelectionService()) {
        self.teamSelectionService = teamSelectionService
        loadTeamData()
    }
    
    // MARK: - Public Methods
    func changeSelectedTeam(_ value: Team) {
        print("📋 팀 선택됨: \(value.name) (ID: \(value.id))")
        selectedTeam = value
    }
    
    func confirmTeam() {
        print("=== 팀 확인 시작 ===")
        
        guard let team = selectedTeam else {
            print("❌ 선택된 팀이 없음")
            errorMessage = "팀을 선택해주세요"
            return
        }
        
        print("✅ 확인된 팀: \(team.name) (ID: \(team.id))")
        postTeamSelection(teamId: team.id)
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    private func loadTeamData() {
        teamData = TeamSelectViewModel.teams

        print("✅ 팀 데이터 로드 완료: \(teamData.flatMap { $0 }.count)개 팀")
    }
    
    private func postTeamSelection(teamId: Int) {
        print("=== 팀 선택 API 호출 시작 ===")
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await teamSelectionService.selectTeam(teamId: teamId)
                
                print("📨 팀 선택 응답:")
                print("  - 코드: \(response.code)")
                print("  - 메시지: \(response.message)")
                print("  - 팀 이름: \(response.data.kboTeamName)")
                
                if response.code == "OK" {
                    print("✅ 팀 선택 성공!")
                    
                    // 상태 업데이트
                    serverMessage = response.message
                    teamConfirm = false
                    shouldNavigate = true
                    
                    // 팀 이름 저장
                    UserPreferences.shared.setTeamName(response.data.kboTeamName)
                    print("💾 팀 이름 저장 완료: \(response.data.kboTeamName)")
                    
                } else {
                    print("❌ 팀 선택 실패: \(response.message)")
                    errorMessage = response.message
                    teamConfirm = false
                }
                
            } catch {
                print("❌ 팀 선택 API 오류: \(error)")
                
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .badServerResponse:
                        errorMessage = "서버에 일시적인 문제가 발생했습니다."
                    case .notConnectedToInternet:
                        errorMessage = "인터넷 연결을 확인해주세요."
                    case .timedOut:
                        errorMessage = "요청 시간이 초과되었습니다."
                    default:
                        errorMessage = "팀 선택 중 오류가 발생했습니다."
                    }
                } else {
                    errorMessage = "팀 선택 중 오류가 발생했습니다: \(error.localizedDescription)"
                }
                
                teamConfirm = false
            }
            
            isLoading = false
            print("=== 팀 선택 API 호출 완료 ===")
        }
    }
}
