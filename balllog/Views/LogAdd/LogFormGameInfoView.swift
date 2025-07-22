//
//  LogFormGameInfoView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI

struct LogFormGameInfoView: View {
    @Binding var gameDate: Date?
    @Binding var myTeam: String
    @Binding var myTeamScore: String
    @Binding var opposingTeam: String
    @Binding var opposingTeamScore: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14.0) {
            HStack {
                DatePickerView(selectedDate: $gameDate)
                Spacer()
                HStack(spacing: 4) {
                    CustomDialView(placeholder: "0", suffix: "응원팀 점수", selectedValue: $myTeamScore)
                    Text(":").bold().font(.system(size: 16))
                    CustomDialView(placeholder: "0", suffix: "상대팀 점수", selectedValue: $opposingTeamScore)
                    Image("under_triangle")
                        .foregroundColor(Color("gray_60"))
                }
            }
            .padding(.horizontal, 14.0)
            DotLineInputView()
            HStack {
                HStack(spacing: 6) {
                    CustomPicker(list: teamList, placeholder: "응원팀", selectedValue: $myTeam, bigSize: true)
                    Text("vs")
                        .bold()
                        .foregroundStyle(Color("gray_60"))
                        .font(.system(size: 14))
                    CustomPicker(list: teamList, placeholder: "상대팀", selectedValue: $opposingTeam, bigSize: true)
                }
                Spacer()
            }
            .padding(.horizontal, 14.0)
        }
        .padding(.vertical, 14.0)
    }

    private var teamList: [String] {
        ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"]
    }
}

#Preview {
    LogAddView()
}
