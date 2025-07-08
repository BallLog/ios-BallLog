//
//  MyPageView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: MyPageViewModel
    @ObservedObject private var preferences = UserPreferences.shared
    
    init(authViewModel: AuthViewModel) {
        self._viewModel = StateObject(wrappedValue: MyPageViewModel(authViewModel: authViewModel))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                // 프로필 헤더
                profileHeaderView
                
                // 설정 메뉴
                settingsMenuView
            }
            .fullScreenCover(isPresented: $viewModel.showLogoutPopup) {
                LogoutPopup(viewModel: viewModel)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Task {
                    await viewModel.loadMyPageProfile()
                }
            }
            .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("확인") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
    
    // MARK: - View Components
    private var profileHeaderView: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(teamMainColor(for: UserPreferences.shared.getTeamName()))
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 7.0) {
                            Text(viewModel.myPageProfile?.nickname ?? "사용자")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Text(preferences.getTeamName())
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
                    Text("승률 \(String(format: "%.0f", preferences.localWinRate))%")
                        .font(.system(size: 12))
                        .foregroundStyle(teamMainColor(for: UserPreferences.shared.getTeamName()))
                }
                Spacer()
                    .frame(height: 8)
                HStack(alignment: .bottom, spacing: 4.0) {
                    Text("\(preferences.winGames)승")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(teamMainColor(for: UserPreferences.shared.getTeamName()))
                    Text("/\(preferences.totalGames)경기")
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
                                .fill(teamMainColor(for: UserPreferences.shared.getTeamName()))
                                .frame(width: geometry.size.width * (preferences.localWinRate / 100.0), height: 6)
                            Spacer()
                        }
                    }
                }
            }
            .frame(height: 62)
            .padding(.top, 14.0)
            .padding(.bottom, 20.0)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color(red: 184/255, green: 184/255, blue: 210/255, opacity: 0.2),
                    radius: 12, x: 0, y: 6)
            .padding(.horizontal, 20.0)
            .offset(y: 100)
        }
        .ignoresSafeArea()
    }
    
    private var settingsMenuView: some View {
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
                        menuItem(icon: "edit_team", title: "응원구단 변경", showChevron: true)
                    }
                    Divider()
                    NavigationLink(destination: ChangeNickNameView()) {
                        menuItem(icon: "edit_nickname", title: "닉네임 변경", showChevron: true)
                    }
                    Divider()
                    NavigationLink(destination: TermsOfUseView()) {
                        menuItem(icon: "policy", title: "이용약관", showChevron: true)
                    }
                    Divider()
                    menuItem(icon: "version", title: "버전정보", rightText: "현재버전 0.1.1")
                    Divider()
                    Button {
                        viewModel.showLogoutConfirmation()
                    } label: {
                        menuItem(icon: "logout", title: "로그아웃", showChevron: false)
                    }
                    Divider()
                    NavigationLink(destination: WithdrawalView(authViewModel: authViewModel)) {
                        menuItem(icon: "resign", title: "회원탈퇴", showChevron: true)
                    }
                }
                .foregroundStyle(Color("gray_70"))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color("gray_40"), lineWidth: 1)
                )
            }
            Spacer()
        }
        .padding(.horizontal, 26.0)
    }
    
    @ViewBuilder
    private func menuItem(icon: String, title: String, showChevron: Bool = false, rightText: String? = nil) -> some View {
        HStack {
            Image(icon)
            Spacer()
                .frame(width: 24)
            Text(title)
            Spacer()
            if let rightText = rightText {
                Text(rightText)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundStyle(Color("gray_70"))
            }
            if showChevron {
                Image("chevron_gray_r")
            }
        }
        .padding(16.0)
    }
}
