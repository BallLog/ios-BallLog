//
//  teamMainColor.swift
//  balllog
//
//  Created by 전은혜 on 4/29/25.
//

import SwiftUI

// MARK: 카드 컴포넌트의 상단 컬러
func teamMainColor(for team: String?) -> Color {
//    TODO: id기반으로 변경
    
    switch team {
    case "삼성 라이온즈":
        return Color("Lions_COL_01")
    case "KIA 타이거즈":
        return Color("Tigers_COL_01")
    case "롯데 자이언츠":
        return Color("Giants_COL_01")
    case "LG 트윈스":
        return Color("Twins_COL_01")
    case "한화 이글스":
        return Color("Eagles_COL_01")
    case "두산 베어스":
        return Color("Bears_COL_01")
    case "KT 위즈":
        return Color("Wizs_COL_01")
    case "NC 다이노스":
        return Color("Dinos_COL_01")
    case "SSG 랜더스":
        return Color("Landers_COL_01")
    case "키움 히어로즈":
        return Color("Heros_COL_01")
    default:
        return Color.gray
    }
}

// MARK: 카드 컴포넌트의 하단 컬러
func teamSubColor(for team: String?) -> Color {
    switch team {
    case "삼성 라이온즈":
        return Color("Lions_COL_01")
    case "KIA 타이거즈":
        return Color("Tigers_COL_02")
    case "롯데 자이언츠":
        return Color("Giants_COL_02")
    case "LG 트윈스":
        return Color("Twins_COL_01")
    case "한화 이글스":
        return Color("Eagles_COL_02")
    case "두산 베어스":
        return Color("Bears_COL_01")
    case "KT 위즈":
        return Color("Wizs_COL_01")
    case "NC 다이노스":
        return Color("Dinos_COL_02")
    case "SSG 랜더스":
        return Color("Landers_COL_01")
    case "키움 히어로즈":
        return Color("Heros_COL_01")
    default:
        return Color.gray
    }
}

// MARK: 미니 카드 컴포넌트의 하단 컬러
func teamBgColor(for team: String?) -> Color {
    switch team {
    case "KIA 타이거즈":
        return Color("Tigers_COL_02")
    case "롯데 자이언츠":
        return Color("Giants_COL_02")
    default:
        return Color.white
    }
}

// MARK: 미니 카드 컴포넌트의 폰트 컬러
func teamFontColor(for team: String?) -> Color {
    switch team {
    case "삼성 라이온즈":
        return Color("Lions_COL_01")
    case "KIA 타이거즈":
        return Color.white
    case "롯데 자이언츠":
        return Color.white
    case "LG 트윈스":
        return Color("Twins_COL_01")
    case "한화 이글스":
        return Color("Eagles_COL_02")
    case "두산 베어스":
        return Color("Bears_COL_01")
    case "KT 위즈":
        return Color("Wizs_COL_01")
    case "NC 다이노스":
        return Color("Dinos_COL_02")
    case "SSG 랜더스":
        return Color("Landers_COL_01")
    case "키움 히어로즈":
        return Color("Heros_COL_01")
    default:
        return Color.gray
    }
}


enum TeamColorType {
    case solid(Color)
    case gradient(LinearGradient)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .solid(let color):
            color
        case .gradient(let gradient):
            gradient
        }
    }
    
    // stroke용 ShapeStyle 추가
    var shapeStyle: AnyShapeStyle {
        switch self {
        case .solid(let color):
            return AnyShapeStyle(color)
        case .gradient(let gradient):
            return AnyShapeStyle(gradient)
        }
    }
}

// MARK: 상세보기 카드 컴포넌트의 텍스트 컬러
func teamThemeFontColor(for team: String?) -> Color {
    switch team {
    case "삼성 라이온즈":
        return Color("Lions_COL_01")
    case "KIA 타이거즈":
        return Color("Tigers_COL_02")
    case "롯데 자이언츠":
        return Color("Giants_COL_02")
    case "LG 트윈스":
        return Color("Twins_COL_01")
    case "한화 이글스":
        return Color("Eagles_COL_01")
    case "두산 베어스":
        return Color("Bears_COL_01")
    case "KT 위즈":
        return Color("Wizs_COL_01")
    case "NC 다이노스":
        return Color("Dinos_COL_01")
    case "SSG 랜더스":
        return Color("Landers_COL_02")
    case "키움 히어로즈":
        return Color("Heros_COL_01")
    default:
        return Color.gray
    }
}

// MARK: 상세보기 카드 컴포넌트의 배경 컬러
func teamThemeBgColor(for team: String?) -> TeamColorType {
    switch team {
        case "삼성 라이온즈":
            return .solid(Color("Lions_COL_01"))
        case "KIA 타이거즈":
            return .gradient(
                LinearGradient(
                    colors: [Color("Tigers_COL_01"), Color("Tigers_COL_02")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        case "롯데 자이언츠":
            return .gradient(
                LinearGradient(
                    colors: [Color("Giants_COL_02"), Color("Giants_COL_01")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        case "LG 트윈스":
            return .solid(Color("Twins_COL_01"))
        case "한화 이글스":
            return .solid(Color("Eagles_COL_01"))
        case "두산 베어스":
            return .solid(Color("Bears_COL_01"))
        case "KT 위즈":
            return .solid(Color("Wizs_COL_01"))
        case "NC 다이노스":
            return .solid(Color("Dinos_COL_01"))
        case "SSG 랜더스":
            return .solid(Color("Landers_COL_02"))
        case "키움 히어로즈":
            return .solid(Color("Heros_COL_01"))
        default:
            return .solid(Color.gray)
        }
}
