//
//  MyPageView.swift
//  balllog
//
//  Created by 전은혜 on 1/11/25.
//

import SwiftUI

struct MyPageView: View {
    @State var shouldPopup: Bool = false // 로그아웃 팝업 상태
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                ZStack {
                    ZStack {
                        Rectangle()
                            .fill(Color("Lions_COL_01"))
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 7.0) {
                                    Text("홈런왕 구자욱")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                    Text("삼성라이온즈")
                                        .font(.system(size: 14))
                                }
                                .foregroundColor(Color.white)
                                .padding(.top, 80.0)
                                .padding(.horizontal, 26.0)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    .frame(height: 200)
                    VStack {
                        HStack {
                            Text("직관 승률")
                                .font(.system(size: 12))
                                .foregroundStyle(Color("gray_70"))
                            Spacer()
                            Text("승률 70%")
                                .font(.system(size: 12))
                                .foregroundStyle(Color("Lions_COL_01"))
                        }
                        Spacer()
                            .frame(height: 8)
                        HStack(alignment: .bottom, spacing: 4.0) {
                            Text("20승")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(Color("Lions_COL_01"))
                            Text("/30경기")
                                .font(.system(size: 10))
                                .padding(.bottom, 4.0)
                                .foregroundStyle(Color("gray_50"))
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 10)
                        GeometryReader { geometry in
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color("gray_20"))
                                    .frame(width: geometry.size.width, height: 6)
                                HStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color("Lions_COL_01"))
                                        .frame(width: geometry.size.width * 0.4, height: 6)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(height: 62)
                    .padding(.top, 14.0)
                    .padding(.bottom, 20.0)
                    .padding(.horizontal, 16)
                    .background(
                        Color.white // 배경을 VStack과 같은 레벨로 설정해야 패딩이 포함됨
                    )
                    .cornerRadius(12)
                    .shadow(color: Color(red: 184/255, green: 184/255, blue: 210/255, opacity: 0.2),
                            radius: 12,
                            x: 0,
                            y: 6)
                    .padding(.horizontal, 20.0)
                    .offset(y: 100)
                }
                .ignoresSafeArea()
                VStack(alignment: .leading) {
                    VStack(spacing: 12.0) {
                        HStack {
                            Text("설정")
                                .fontWeight(.medium)
                                .padding(.leading, 2.0)
                                .foregroundStyle(Color("gray_70"))
                            Spacer()
                        }
                        VStack(spacing: 0.0) {
                            NavigationLink(destination: ChangeTeamSelectView()) {
                                HStack {
                                    Image("edit_team")
                                    Spacer()
                                        .frame(width: 24)
                                    Text("응원구단 변경")
                                    Spacer()
                                    Image("chevron_gray_r")
                                }
                                .padding(16.0)
                            }
                            Divider()
                            NavigationLink(destination: ChangeNickNameView()) {
                                HStack {
                                    Image("edit_nickname")
                                    Spacer()
                                        .frame(width: 24)
                                    Text("닉네임 변경")
                                    Spacer()
                                    Image("chevron_gray_r")
                                }
                                .padding(16.0)
                            }
                            Divider()
                                .foregroundStyle(Color("gray_40"))
                            NavigationLink(destination: TermsOfUseView()) {
                                HStack {
                                    Image("policy")
                                    Spacer()
                                        .frame(width: 24)
                                    Text("이용약관")
                                    Spacer()
                                    Image("chevron_gray_r")
                                }
                                .padding(16.0)
                            }
                            Divider()
                                .foregroundStyle(Color("gray_40"))
                            HStack {
                                Image("version")
                                Spacer()
                                    .frame(width: 24)
                                Text("버전정보")
                                Spacer()
                                Text("현재버전 0.1.1")
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("gray_70"))
                            }
                            .padding(16.0)
                            Divider()
                                .foregroundStyle(Color("gray_40"))
                            Button {
                                shouldPopup = true
                            } label: {
                                HStack {
                                    Image("logout")
                                    Spacer()
                                        .frame(width: 24)
                                    Text("로그아웃")
                                    Spacer()
                                }
                                .padding(16.0)
                            }
                            Divider()
                                .foregroundStyle(Color("gray_40"))
                            NavigationLink(destination: WithdrawelView()) {
                                HStack {
                                    Image("resign")
                                    Spacer()
                                        .frame(width: 24)
                                    Text("회원탈퇴")
                                    Spacer()
                                    Image("chevron_gray_r")
                                }
                                .padding(16.0)
                            }
                        }
                        .foregroundStyle(Color("gray_70"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6) // 상단 모서리만 둥글게
                                .stroke(Color("gray_40"), lineWidth: 1) // 테두리 컬러 및 두께 설정
                        )
                    }
                    Spacer()
                }
                .padding(.horizontal, 26.0)
            }
            .fullScreenCover(isPresented: $shouldPopup) {
                LogoutPopup()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MyPageView()
}
