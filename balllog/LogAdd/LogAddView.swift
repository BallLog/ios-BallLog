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
                    Spacer()
                        .frame(height: 16.0)
                    // 볼로그 내용
                    VStack (spacing: 30.0) {
                        // 제목
                        CustomInputView(label: "제목", text: $title, placeholder: "제목을 입력해주세요")
                            .focused($isFocused)
                        HStack{
                            // 경기 날짜
                            
                            // 경기구장
                            CustomPicker(title: "경기구장", list: ["광주 KIA챔피언스", "대구 삼성라이온즈파크", "잠실야구장", "수원 KT 위즈파크", "인천 SSG랜더스필드", "사직야구장", "대전 한화생명볼파크", "창원 NC파크", "고척스카이돔", "기타"], placeholder: "구장선택", selectedValue: $stadium)
                        }
                        HStack {
                            // 응원팀
                            CustomPicker(title: "응원팀", list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: $myTeam)
                                .frame(width: 214)
                            // 상대팀
                            CustomPicker(title: "상대팀", list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: $opposingTeam)
                                .frame(width: 214)
                        }
                        HStack {
                            // 응원팀
                            CustomDialView(title: "점수", placeholder: "점수", selectedValue: $opposingTeamScore)
                                .frame(width: 106)
                            // 상대팀
                            CustomDialView(title: "점수", placeholder: "점수", selectedValue: $myTeamScore)
                                .frame(width: 106)
                        }
                        // 사진 리스트
                        PhotoPickerView(selectedItems: $photoList)
                        // 내용
                        CustomInputView(label: "내용", isArea: true, text: $logContent, placeholder: "내용을 입력하세요")
                            .focused($isFocused)
                        
                    }
                    .padding(.horizontal, 20.0)
                    Spacer().frame(height: 100)
                }
                .padding(.top, 60.0)
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
