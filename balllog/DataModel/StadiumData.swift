//
//  StadiumData.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

struct Stadium: Identifiable, Hashable {
    let id: Int
    let name: String
}

class StadiumData {
    static let shared = StadiumData()
    
    let stadiums: [Stadium] = [
        Stadium(id: 1, name: "광주-기아 챔피언스 필드"), Stadium(id: 2, name: "대구 삼성 라이온즈 파크"),
        Stadium(id: 3, name: "서울 종합운동장 야구장"), Stadium(id: 4, name: "수원 케이티 위즈 파크"),
        Stadium(id: 5, name: "사직 야구장"), Stadium(id: 6, name: "대전 한화생명 볼파크"),
        Stadium(id: 7, name: "고척 스카이돔"), Stadium(id: 8, name: "창원 NC 파크"),
        Stadium(id: 9, name: "인천 SSG 랜더스 필드"),
    ]
    
    
    // ID로 구장 찾기
    func findNameOfStadium(by id: Int) -> String? {
        stadiums.first { $0.id == id }?.name ?? "-"
    }
    
    // 이름으로 구장 찾기
    func findIdOfStadium(by name: String) -> Int? {
        stadiums.first { $0.name == name }?.id ?? 0
    }
    
}
