//
//  TeamCardBackground.swift
//  balllog
//
//  Created by 전은혜 on 3/21/25.
//

import SwiftUI

func teamGradient(for team: String) -> LinearGradient {
    switch team {
    case "LIONS":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Lions_COL_01"), Color("Lions_COL_01")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case "TIGERS":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Tigers_COL_01"), Color("Tigers_COL_02")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "GIANTS":
        return LinearGradient(
            gradient: Gradient(colors: [Color("Giants_COL_02"), Color("Giants_COL_01")]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "TWINS":
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
