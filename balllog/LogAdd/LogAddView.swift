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
    @State private var selection: NavigationDestination? = nil // 네비게이션

    @State private var photoList: [PhotosPickerItem] = []
    @State private var title: String = ""
    @State private var logContent: String = ""
    @State private var myTeam: String = ""
    @State private var myTeamScore: String = ""
    @State private var opposingTeam: String = ""
    @State private var opposingTeamScore: String = ""
    @State private var stadium: String = ""
    @State private var shouldNavigate: Bool = false
    
    
    @FocusState private var isFocused: Bool
    

    var body: some View {
        NavigationStack() {
            ZStack {
                // 터치영역
                Color.white
                
                ScrollView {
                    ZStack {
                        Image("card")
                        VStack {
                            Spacer()
                                .frame(height: 10.0)
                            // 볼로그 내용
                            VStack (alignment: .leading, spacing: 9) {
                                // 제목
                                TextInputView(text: $title, placeholder: "제목을 입력해 주세요", fontWeight: .bold)
                                    .focused($isFocused)
                                VStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: 4.0) {
                                        HStack{
                                            // 경기 날짜
                                            
                                            // 경기구장
                                            CustomPicker(list: ["광주 KIA챔피언스", "대구 삼성라이온즈파크", "잠실야구장", "수원 KT 위즈파크", "인천 SSG랜더스필드", "사직야구장", "대전 한화생명볼파크", "창원 NC파크", "고척스카이돔", "기타"], placeholder: "경기 구장 선택", selectedValue: $stadium, bigSize: false)
                                        }
                                        HStack {
                                            HStack (spacing: 6) {
                                                // 응원팀
                                                CustomPicker(list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "응원팀 선택", selectedValue: $myTeam, bigSize: true)
                                                Text("VS")
                                                    .font(.system(size: 14))
                                                    .bold()
                                                // 상대팀
                                                CustomPicker(list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "상대팀 선택", selectedValue: $opposingTeam, bigSize: true)
                                            }
                                            Spacer()
                                            HStack (spacing: 3) {
                                                // 응원팀
                                                CustomDialView( placeholder: "0", selectedValue: $opposingTeamScore)
                                                Text(":")
                                                    .font(.system(size: 14))
                                                    .bold()
                                                // 상대팀
                                                CustomDialView( placeholder: "0", selectedValue: $myTeamScore)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 12.0)
                                    .padding(.horizontal, 14.0)
                                    
                                    VStack(spacing: 0) {
                                        // 사진 리스트
                                        Rectangle()
                                            .stroke(style: StrokeStyle(
                                                lineWidth: 1,
                                                lineCap: .square,
                                                dash: [5, 5]
                                            ))
                                            .frame(height: 1)
                                            .foregroundColor(Color("gray_60"))
                                        // 사진 리스트
                                        PhotoPickerView(selectedItems: $photoList)
                                        Rectangle()
                                            .stroke(style: StrokeStyle(
                                                lineWidth: 1,
                                                lineCap: .square,
                                                dash: [5, 5]
                                            ))
                                            .frame(height: 1)
                                            .foregroundColor(Color("gray_60"))
                                    }
                                    
                                    // 내용
                                    VStack {
                                        TextAreaView(text: $logContent, placeholder: "직관 소감을 작성해 주세요.") .focused($isFocused)
                                    }
                                    .padding(.horizontal, 13.0)
                                    .padding(.vertical, 10.0)
                                    
                                    VStack {
                                        Rectangle()
                                            .frame(height: 1)  // 선의 두께 설정
                                            .foregroundColor(Color("gray_60"))
                                        
                                        VStack (spacing: 5.0) {
                                            // 승률 텍스트
                                            HStack(alignment: .center) {
                                                Text("직관 승률 70%")
                                                    .font(.custom("Pretendard Variable", size: 12))
                                                    .fontWeight(.medium)
                                                    .lineSpacing(0)
                                                    .kerning(0)
                                                Spacer()
                                                HStack(alignment: .center, spacing: 6.0) {
                                                    Text("020승")
                                                        .font(.custom("Pretendard Variable", size: 18))
                                                        .fontWeight(.bold)
                                                        .lineSpacing(0)
                                                        .kerning(0)
                                                    Text("/ 030경기")
                                                        .font(.custom("Pretendard Variable", size: 10))
                                                        .fontWeight(.regular)
                                                        .lineSpacing(0)
                                                        .kerning(0)
                                                }
                                            }
                                            GeometryReader { geometry in
                                                ZStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .strokeBorder(Color("gray_60"), lineWidth: 1)
                                                        .frame(height: 6)
                                                    Rectangle()
                                                        .background(Color("gray_60"))
                                                        .frame(width: geometry.size.width * 0.5, height: 6)
                                                        .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
                                                }
                                            }
                                        }
                                        .foregroundStyle(Color("gray_60"))
                                        .padding(.horizontal, 16.0)
                                    }
                                    .padding(.vertical, 16)
                                }
                                .cornerRadius(3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color("gray_60"), lineWidth: 1.0)
                                )
                            }
                            .padding(.horizontal, 20.0)
                            HStack {
                                Spacer()
                                Text("BALL-LOG")
                                    .font(.custom("Playpen Sans", size: 12))
                                    .foregroundStyle(Color("gray_60"))
                                    .fontWeight(.regular)
                                    .lineSpacing(3)
                                    .kerning(14)
                                    .frame(maxHeight: .infinity, alignment: .center)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    }
                }
                .padding(.top, 70.0)
                .navigationBarBackButtonHidden(true)
                
                // 고정 뷰 (헤더, 버튼)
                VStack {
                    // 헤더
                    DetailHeaderView(title:"볼로그 작성")
                    
                    Spacer()
                    GeometryReader { geometry in
                        VStack {
                            Button("저장") {
                                print("제출이에용~!")
                                selection = .detail
                            }
                            .buttonStyle(CustomButtonStyle())
                            .modifier(DefaultButtonWidth(width: geometry.size.width - 40))
                        }
                        .frame(height: 80.0)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 8.6, x: 0, y: -1)
                    }
                    .frame(height: 80.0)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .simultaneousGesture( // ✅ UI 요소 터치 시 키보드 숨김
                TapGesture().onEnded { isFocused = false }
            )
            .navigationDestination(for: NavigationDestination.self) { value in
                if value == .detail {
                    BallLogDetailView()
                }
            }
        }
    }
}

#Preview {
    LogAddView()
}
