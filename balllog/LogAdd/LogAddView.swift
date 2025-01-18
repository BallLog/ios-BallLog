//
//  LogAddView.swift
//  balllog
//
//  Created by 전은혜 on 1/11/25.
//

import SwiftUI

struct LogAddView: View {
    @State private var title: String = ""
    @State private var logContent: String = ""

    var body: some View {
        VStack {
            // 헤더
            HStack {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .foregroundColor(Color("gray_90"))
                    .fontWeight(.semibold)
                    .scaledToFit()
                    .frame(width: 12, height: 21)
                Spacer()
                Text("볼로그 작성")
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                Spacer()
            }
            .frame(height: 60)
            .padding(.horizontal, 25.5)
            .padding(.vertical, 21.25)
            Spacer()
                .frame(height: 16.0)
            // 볼로그 내용
            VStack (spacing: 30.0) {
                // 사진 리스트
                HStack {
                    ZStack {
                        Rectangle()
                            .cornerRadius(4)
                            .frame(width: 86, height: 86)
                            .foregroundColor(Color("gray_20"))
                        VStack (spacing: 2) {
                            Image(systemName: "camera")
                                .foregroundColor(Color("gray_50"))
                                .frame(width: 24.0, height: 24.0)
                            HStack (spacing: 0) {
                                Text("0")
                                    .fontWeight(.semibold)
                                Text("/4")
                                    .fontWeight(.light)
                            }
                            .font(.system(size: 14))
                            .foregroundColor(Color("gray_50"))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                // 제목
                CustomInputView(label: "제목", text: $title, placeholder: "제목을 입력해주세요")
                
                HStack {
                    // 응원팀
                    CustomPicker(title: "응원팀", list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: .constant(""))
                        .frame(width: 214)
                    Spacer()
                    CustomPicker(title: "점수", list: ["1", "2", "3"], placeholder: "점수", selectedValue: .constant(""))
                        .frame(width: 106)
                }
                HStack {
                    // 상대팀
                    CustomPicker(title: "상대팀", list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: .constant(""))
                        .frame(width: 214)
                    Spacer()
                    CustomPicker(title: "점수", list: ["1", "2", "3"], placeholder: "점수", selectedValue: .constant(""))
                        .frame(width: 106)
                }
                // 경기 날짜
                
                // 경기구장
                CustomPicker(title: "경기구장", list: ["광주 KIA챔피언스", "대구 삼성라이온즈파크", "잠실야구장", "수원 KT 위즈파크", "인천 SSG랜더스필드", "사직야구장", "대전 한화생명볼파크", "창원 NC파크", "고척스카이돔", "기타"], placeholder: "구장선택", selectedValue: .constant(""))
                // 내용
                CustomInputView(label: "내용", isArea: true, text: $logContent, placeholder: "내용을 입력하세요")

            }
            .padding(.horizontal, 20.0)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LogAddView()
}
