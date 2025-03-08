//
//  LogAddView.swift
//  balllog
//
//  Created by 전은혜 on 1/11/25.
//

import SwiftUI
import PhotosUI

struct LogAddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var photoList: [PhotosPickerItem] = []
    @State private var title: String = ""
    @State private var logContent: String = ""
    @State private var myTeam: String = ""
    @State private var myTeamScore: String = ""
    @State private var opposingTeam: String = ""
    @State private var opposingTeamScore: String = ""
    @State private var stadium: String = ""
    

    var body: some View {
        ZStack {
            VStack {
                // 헤더
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .foregroundColor(Color("gray_90"))
                            .fontWeight(.semibold)
                            .scaledToFit()
                            .frame(width: 12, height: 21)
                    }
                    Spacer()
                    Text("볼로그 작성")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                    Spacer()
                }
                .padding(.horizontal, 25.5)
                .padding(.vertical, 21.25)
                Spacer()
                    .frame(height: 16.0)
                // 볼로그 내용
                VStack (spacing: 30.0) {
                    // 사진 리스트
                    PhotoPickerView(selectedItems: $photoList)
                    // 제목
                    CustomInputView(label: "제목", text: $title, placeholder: "제목을 입력해주세요")
                    
                    HStack {
                        // 응원팀
                        CustomPicker(title: "응원팀", list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: $myTeam)
                            .frame(width: 214)
                        Spacer()
                        CustomDialView(title: "점수", placeholder: "점수", selectedValue: $myTeamScore)
                            .frame(width: 106)
                    }
                    HStack {
                        // 상대팀
                        CustomPicker(title: "상대팀", list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: $opposingTeam)
                            .frame(width: 214)
                        Spacer()
                        CustomDialView(title: "점수", placeholder: "점수", selectedValue: $opposingTeamScore)
                            .frame(width: 106)
                    }
                    // 경기 날짜
                    
                    // 경기구장
                    CustomPicker(title: "경기구장", list: ["광주 KIA챔피언스", "대구 삼성라이온즈파크", "잠실야구장", "수원 KT 위즈파크", "인천 SSG랜더스필드", "사직야구장", "대전 한화생명볼파크", "창원 NC파크", "고척스카이돔", "기타"], placeholder: "구장선택", selectedValue: $stadium)
                    // 내용
                    CustomInputView(label: "내용", isArea: true, text: $logContent, placeholder: "내용을 입력하세요")
                    
                }
                .padding(.horizontal, 20.0)
            }
            .navigationBarBackButtonHidden(true)
        }
        VStack {
            Button("저장") {
                print("제출이에용")
            }
            .buttonStyle(CustomButtonStyle())
            .modifier(DefaultButtonWidth())
        }
        .frame(width: .infinity, height: 80.0)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 8.6, x: 0, y: -1)
    }
}

#Preview {
    LogAddView()
}
