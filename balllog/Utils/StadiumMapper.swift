//
//  StadiumMapper.swift
//  balllog
//
//  Created by 전은혜 on 7/29/25.
//

struct StadiumMapper {
    static func name(for id: Int) -> String {
        switch id {
        case 1: return "광주-기아 챔피언스 필드"
        case 2: return "대구 삼성 라이온즈 파크"
        case 3: return "서울 종합운동장 야구장"
        case 4: return "수원 케이티 위즈 파크"
        case 5: return "사직 야구장"
        case 6: return "대전 한화생명 볼파크"
        case 7: return "고척 스카이돔"
        case 8: return "창원 NC 파크"
        case 9: return "인천 SSG 랜더스 필드"
        default: return "알 수 없음"
        }
    }
}
