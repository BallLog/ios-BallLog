//
//  teamMainColor.swift
//  balllog
//
//  Created by 전은혜 on 4/29/25.
//

import SwiftUI

func teamMainColor(for team: String?) -> Color {
    switch team {
    case "LIONS":
        return Color("Lions_COL_01")
    case "TIGERS":
        return Color("Tigers_COL_01")
    case "GIANTS":
        return Color("Giants_COL_02")
    case "TWINS":
        return Color("Twins_COL_01")
    default:
        return Color.gray
    }
}


func teamSubColor(for team: String?) -> Color {
    switch team {
    case "LIONS":
        return Color("Lions_COL_01")
    case "TIGERS":
        return Color("Tigers_COL_02")
    case "GIANTS":
        return Color("Giants_COL_01")
    case "TWINS":
        return Color("Twins_COL_02")
    default:
        return Color.gray
    }
}
