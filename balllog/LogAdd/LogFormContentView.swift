//
//  LogFormContentView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI
import PhotosUI

struct LogFormContentView: View {
    @Binding var title: String
    @Binding var gameDate: Date?
    @Binding var stadium: String
    @Binding var myTeam: String
    @Binding var myTeamScore: String
    @Binding var opposingTeam: String
    @Binding var opposingTeamScore: String
    @Binding var photoList: [PhotosPickerItem]
    @Binding var logContent: String
    @FocusState var isFocused: Bool
    


    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image("write")
                TextInputView(text: $title, placeholder: "제목을 입력해 주세요", fontWeight: .bold)
                    .focused($isFocused)
            }
            .padding(.top, 14)

            VStack (alignment: .leading, spacing: 0){
                LogFormGameInfoView(
                    gameDate: $gameDate,
                    myTeam: $myTeam,
                    myTeamScore: $myTeamScore,
                    opposingTeam: $opposingTeam,
                    opposingTeamScore: $opposingTeamScore
                )

                VStack(spacing: 0) {
                    DotLineInputView()

                    PhotoPickerView(selectedItems: $photoList)

                    DotLineInputView()
                }

                VStack {
                    TextAreaView(text: $logContent, placeholder: "직관 소감을 작성해 주세요.")
                        .focused($isFocused)
                }
                .padding(.horizontal, 14.0)
                .padding(.vertical, 10.0)

                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 1).foregroundColor(Color("gray_40"))

                    HStack(spacing: 0) {
                        // 왼쪽 승률 박스
                        VStack(alignment:.leading, spacing: 6.0) {
                            Text("직관 승률 70%")
                                .font(.custom("Pretendard Variable", size: 12))
                                .fontWeight(.medium)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .strokeBorder(Color("gray_60"), lineWidth: 1)
                                        .frame(height: 6)
                                    Rectangle()
                                        .frame(width: geometry.size.width * 0.7, height: 6)
                                        .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
                                }
                            }
                            .frame(height: 6)
                        }
                        .foregroundStyle(Color("gray_60"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity) // 좌우 동일한 크기
                        
                        // 중간 구분선
                        Rectangle()
                            .frame(width: 1, height: 51)
                            .foregroundColor(Color("gray_40"))
                        
                        VStack {
                            CustomPicker(
                                list: ["광주 KIA챔피언스", "대구 삼성라이온즈파크", "잠실야구장", "수원 KT 위즈파크", "인천 SSG랜더스필드", "사직야구장", "대전 한화생명볼파크", "창원 NC파크", "고척스카이돔", "기타"],
                                placeholder: "경기 구장",
                                selectedValue: $stadium,
                                bigSize: false
                            )
                        }
                        .padding(.horizontal, 14.0)
                        .padding(.vertical, 12.0)
                        .frame(maxWidth: .infinity) // 좌우 동일한 크기
                    }
                    .frame(height: 51) // 전체 높이 제한
                }
            }
            .background(Color.white) // 필요시 배경색 추가
            .overlay(
               Rectangle()
                   .stroke(Color("gray_40"), lineWidth: 1.0)
            )
            Spacer()
        }
        .padding(14)
    }
}
