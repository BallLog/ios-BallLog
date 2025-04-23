//
//  TeamSelectViewModel.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import Foundation
import Combine

class TeamSelectViewModel: ObservableObject {
    // team data
    @Published var teamData: [[Team]]

    // 상태 관리
    @Published var shouldNavigate: Bool = false
    @Published var teamConfirm: Bool = false
    @Published var selectedTeam: Team?
    @Published var serverMessage: String?
    @Published var errorMessage: String?

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

    // ✅ Combine으로 API 호출
    private func postTeamSelection(teamId: Int) {
        guard let urlString = APIUtils.getApiUrl(), let url = URL(string: urlString + "/v1/user/my-kbo-team") else {
               print("API URL을 찾을 수 없습니다.")
               return
           }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: bearer token으로 변경
        request.addValue("a8f68ae33e5c4ccea216fa656d89e8c1", forHTTPHeaderField: "x-api-key")

        let body = ["kboTeamId": teamId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: TeamSelectionResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessage = "에러 발생: \(error.localizedDescription)"
                    self.teamConfirm = false
                }
            } receiveValue: { response in
                self.serverMessage = response.message
                self.teamConfirm = response.code == "OK"
                self.shouldNavigate = response.code == "OK"

                // ✅ teamName 저장
                UserDefaults.standard.set(response.data.kboTeamName, forKey: "teamName")
            }
            .store(in: &cancellables)
    }
}
