//
//  TeamCardBackground.swift
//  balllog
//
//  Created by 전은혜 on 3/21/25.
//

import SwiftUI

// MARK: 카드 컴포넌트 풀컬러(그라디언트, 일부 단색)
func teamGradient(for team: String) -> LinearGradient {
    //    TODO: id기반으로 변경
    switch team {
    case "삼성 라이온즈":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Lions_COL_01"), Color("Lions_COL_01")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case "KIA 타이거즈":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Tigers_COL_01"), Color("Tigers_COL_02")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "롯데 자이언츠":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Giants_COL_02"), Color("Giants_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "LG 트윈스":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Twins_COL_01"), Color("Twins_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "한화 이글스":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Eagles_COL_01"), Color("Eagles_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "두산 베어스":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Bears_COL_01"), Color("Bears_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "KT 위즈":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Wizs_COL_01"), Color("Wizs_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "NC 다이노스":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Dinos_COL_01"), Color("Dinos_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "SSG 랜더스":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Landers_COL_02"), Color("Landers_COL_02")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "키움 히어로즈":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Heros_COL_01"), Color("Heros_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    default:
        return LinearGradient(
            gradient: Gradient(colors: [Color.gray, Color.gray]), // 기본 단색 처리
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
