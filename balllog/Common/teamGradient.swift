//
//  TeamCardBackground.swift
//  balllog
//
//  Created by 전은혜 on 3/21/25.
//

import SwiftUI

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
            gradient: Gradient(colors: [Color("Twins_COL_02"), Color("Twins_COL_01")]),
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
