//
//  BallLogDetail.swift
//  balllog
//
//  Created by 전은혜 on 3/20/25.
//

import SwiftUI

struct BallLogDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selection: NavigationDestination? = nil // 네비게이션

    // 응원팀
    var myTeam = "GIANTS"

    var body: some View {
        NavigationStack() {
            ZStack {
                // 터치영역
                Color.white
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            Spacer()
                                .frame(minHeight: 8.0)
                            // 카드
                            ZStack {
                                Image("card")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 335, height: 415)
                                    .overlay(
                                        teamGradient(for: myTeam)
                                    )
                                    .blendMode(.multiply)
                                VStack(spacing: 0.0) {
                                    // Header
                                    HStack(alignment: .center) {
                                        Image("logo")
                                        Text("BALL-LOG")
                                            .font(.custom("Playpen Sans", size: 10))
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.medium)
                                            .lineSpacing(5)
                                            .kerning(9)
                                            .frame(maxHeight: .infinity, alignment: .center)
                                        Spacer()
                                        HStack(spacing: 3.0) {
                                            Image("winner")
                                            Text("WINNER")
                                                .font(.custom("Pretendard Variable", size: 7))
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .lineSpacing(13)
                                                .kerning(2)
                                                .frame(maxHeight: .infinity, alignment: .center)
                                        }
                                        .padding(.horizontal, 5.0)
                                        .frame(width: 63.0, height: 13.0)
                                        .background(Color("y_50"))
                                        .cornerRadius(53)
                                    }
                                    Spacer()
                                        .frame(height: 7.0)
                                    // Center
                                    VStack(spacing: 0) {
                                        // 경기 요약
                                        VStack(alignment: .leading) {
                                            // 날짜
                                            HStack {
                                                Text("2024/10/02")
                                                    .font(.custom("Pretendard Variable", size: 8))
                                                    .foregroundStyle(Color.white)
                                                    .fontWeight(.regular)
                                                    .lineSpacing(0)
                                                    .kerning(0)
                                                    .frame(maxHeight: .infinity, alignment: .center)
                                                    .multilineTextAlignment(.trailing)
                                                Spacer()
                                            }
                                            .padding(.top, 12.0)
                                            .padding(.horizontal, 14.0)
                                            // 팀 & 점수
                                            HStack {
                                                Text("KIA 타이거즈 VS 삼성라이온즈")
                                                    .font(.custom("Pretendard Variable", size: 14))
                                                    .fontWeight(.bold)
                                                    .lineSpacing(6)
                                                    .kerning(0)
                                                    .frame(maxHeight: .infinity, alignment: .center)
                                                Spacer()
                                                Text("14 : 16")
                                                    .font(.custom("Pretendard Variable", size: 16))
                                                    .fontWeight(.bold)
                                                    .lineSpacing(4)
                                                    .kerning(2)
                                                    .multilineTextAlignment(.trailing)
                                            }
                                            .padding(.horizontal, 14.0)
                                            .foregroundStyle(Color.white)
                                            Spacer()
                                                .frame(height: 8.0)
                                        }
                                        .frame(height: 52.0)
                                        // 경기 사진
                                        VStack(spacing: 0) {
                                            Rectangle()
                                                .strokeBorder(style: StrokeStyle(
                                                    lineWidth: 1,
                                                    lineCap: .square,
                                                    dash: [4, 9]
                                                ))
                                                .frame(height: 1)
                                                .foregroundColor(.white)
                                            Rectangle()
                                                .frame(width: 295, height: 229)
                                                .foregroundStyle(Color("gray_40"))
                                            Rectangle()
                                                .strokeBorder(style: StrokeStyle(
                                                    lineWidth: 1,
                                                    lineCap: .square,
                                                    dash: [4, 9]
                                                ))
                                                .frame(height: 1)
                                                .foregroundColor(.white)
                                        }
                                        // 승률
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
                                                        .strokeBorder(Color.white, lineWidth: 1)
                                                        .frame(height: 6)
                                                    Rectangle()
                                                        .background(Color.white)
                                                        .frame(width: geometry.size.width * 0.5, height: 6)
                                                        .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16.0)
                                        .padding(.top, 12.0)
                                        .padding(.bottom, 15.0)
                                        .foregroundStyle(Color.white)
                                    }
                                    .frame(width: 295, height: 339) // 박스 크기 설정
                                    .cornerRadius(3) // radius 3px 적용
                                    .overlay( // 테두리 추가
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                    Spacer()
                                        .frame(height: 10.0)
                                    HStack {
                                        Spacer()
                                        Text(myTeam)
                                            .font(.custom("Playpen Sans", size: 12))
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.regular)
                                            .lineSpacing(3)
                                            .kerning(14)
                                            .frame(maxHeight: .infinity, alignment: .center)
                                    }
                                }
                                .padding(.vertical, 14.0)
                                .padding(.horizontal, 20.0)
                                .frame(width: 335, height: 415)
                                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                            }
                            Spacer()
                                .frame(minHeight: 22.0)
                            // 대표사진 변경
                            VStack(alignment: .leading) {
                                Text("사진 선택")
                                    .fontWeight(.semibold)
                                    .padding(.leading, 5.0)
                                Spacer()
                                    .frame(height: 10.0)
                                HStack {
                                    ForEach(0..<3) { index in
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: 100, height: 100)
                                            .foregroundStyle(Color("gray_40"))
                                        // 마지막 아이템 뒤에는 Spacer를 추가하지 않음
                                        if index != 2 {
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20.0)
                            .frame(maxWidth: .infinity)
                            
                        }
                        .padding(.top, 60.0)
                        .padding(.bottom, 73.0)
                    }
                    .frame(minHeight: geometry.size.height)
                    .navigationBarBackButtonHidden(true)
                }
                
                // 고정 뷰 (헤더, 버튼)
                VStack {
                    // 헤더
                    DetailHeaderView(title: "볼로그")
                    
                    Spacer()
                    HStack(alignment: .center) {
                        VStack(spacing: 3.0) {
                            Image("share")
                            Text("공유")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .lineSpacing(20)
                                .kerning(0)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 45, height: 45)
                        Spacer()
                            .frame(width: 14)
                        VStack(spacing: 3.0) {
                            Image("delete")
                            Text("삭제")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .lineSpacing(20)
                                .kerning(0)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 45, height: 45)
                        Spacer()
                            .frame(width: 22)
                        Button("수정하기") {
                            print("제출이에용~~")
                            selection = .edit
                        }
                        .buttonStyle(RoundedButtonStyle())
                        .modifier(DefaultButtonWidth(width: 209))
                    }
                    .frame(height: 73.0)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("gray_30")), alignment: .top
                    )
                }
            }
            .navigationDestination(for: NavigationDestination.self) { value in
                if value == .edit {
                    LogAddView()
                }
            }
        }
    }
    
    
}

#Preview {
    BallLogDetailView()
}
