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
    
    let serviceVM: ServiceViewModel

    init(authViewModel: AuthViewModel, serviceVM: ServiceViewModel) {
        self._viewModel = StateObject(wrappedValue: MyPageViewModel(authViewModel: authViewModel))
        self.serviceVM = serviceVM
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                // 프로필 헤더
                profileHeaderView
                
                // 설정 메뉴
                settingsMenuView
            }
            .padding(.bottom, 76.0)
            .fullScreenCover(isPresented: $viewModel.showLogoutPopup) {
                LogoutPopup(viewModel: viewModel)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // 마이페이지가 나타날 때 탭바 표시
                serviceVM.showTabBarAgain()
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
                    .fill(teamMyColor(for: UserPreferences.shared.getTeamName()))
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 7.0) {
                            Text(viewModel.myPageProfile?.nickname ?? "사용자")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Text(preferences.getTeamName())
                                .font(.system(size: 16))
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
                        .font(.system(size: 14))
                        .bold()
                        .foregroundStyle(teamMyColor(for: UserPreferences.shared.getTeamName()))
                }
                Spacer()
                    .frame(height: 12)
                HStack(alignment: .bottom, spacing: 4.0) {
                    Text("\(preferences.winGames)승")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(teamMyColor(for: UserPreferences.shared.getTeamName()))
                    Text("/\(preferences.totalGames)경기")
                        .font(.system(size: 12))
                        .padding(.bottom, 4.0)
                        .foregroundStyle(Color("gray_50"))
                    Spacer()
                }
                Spacer()
                    .frame(height: 8)
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color("gray_20"))
                            .frame(width: geometry.size.width, height: 8)
                        HStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(teamMyColor(for: UserPreferences.shared.getTeamName()))
                                .frame(width: geometry.size.width * (preferences.localWinRate / 100.0), height: 8)
                            Spacer()
                        }
                    }
                }
            }
            .frame(height: 62)
            .padding(.top, 16.0)
            .padding(.bottom, 22.0)
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
                        .foregroundStyle(Color("gray_60"))
                    Spacer()
                }
                VStack(spacing: 0.0) {
                    NavigationLink(destination: ChangeTeamSelectView()
                        .onAppear {
                            print("🔴 응원구단 변경 화면 - 탭바 숨김")
                            serviceVM.hideTabBar()
                        }
                        .onDisappear {
                            print("🟢 응원구단 변경 화면 종료 - 탭바 표시")
                            serviceVM.showTabBarAgain()
                        }
                    ) {
                        menuItem(icon: "edit_team", title: "응원구단 변경", showChevron: true)
                    }
                    Divider()
                        .overlay(Color("bc_01_05"))
                    NavigationLink(destination: ChangeNicknameView()
                        .onAppear {
                            print("🔴 닉네임 변경 화면 - 탭바 숨김")
                            serviceVM.hideTabBar()
                        }
                        .onDisappear {
                            print("🟢 닉네임 변경 화면 종료 - 탭바 표시")
                            serviceVM.showTabBarAgain()
                        }
                    ) {
                        menuItem(icon: "edit_nickname", title: "닉네임 변경", showChevron: true)
                    }
                    Divider()
                        .overlay(Color("bc_01_05"))
                    NavigationLink(destination: TermsDetailView(contentType: .terms)
                        .onAppear {
                            print("🔴 이용약관 화면 - 탭바 숨김")
                            serviceVM.hideTabBar()
                        }
                        .onDisappear {
                            print("🟢 이용약관 화면 종료 - 탭바 표시")
                            serviceVM.showTabBarAgain()
                        }
                    ) {
                        menuItem(icon: "policy", title: "이용약관", showChevron: true)
                    }
                    Divider()
                        .overlay(Color("bc_01_05"))
                    menuItem(icon: "version", title: "버전정보", rightText: "현재버전 0.1.1")
                    Divider()
                        .overlay(Color("bc_01_05"))
                    Button {
                        viewModel.showLogoutConfirmation()
                    } label: {
                        menuItem(icon: "logout", title: "로그아웃", showChevron: false)
                    }
                    Divider()
                        .overlay(Color("bc_01_05"))
                    NavigationLink(
                        destination: WithdrawalView(authViewModel: authViewModel)
                        .onAppear {
                            print("🔴 회원탈퇴 화면 - 탭바 숨김")
                            serviceVM.hideTabBar()
                        }
                        .onDisappear {
                            print("🟢 회원탈퇴 화면 종료 - 탭바 표시")
                            serviceVM.showTabBarAgain()
                        }
                    
                    ) {
                        menuItem(icon: "resign", title: "회원탈퇴", showChevron: true)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color("bc_01_05"), lineWidth: 1)
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
                .foregroundStyle(Color("gray_70"))
            Spacer()
            if let rightText = rightText {
                Text(rightText)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundStyle(Color("gray_50"))
            }
            if showChevron {
                Image("chevron_gray_r")
            }
        }
        .padding(16.0)
    }
}


#Preview("기본 상태") {
    // Mock AuthViewModel for preview
    let mockAuthViewModel = AuthViewModel()
    let mockViewModel = ServiceViewModel()
    
    return MyPageView(authViewModel: mockAuthViewModel, serviceVM: mockViewModel)
        .environmentObject(mockAuthViewModel)
        .onAppear {
            // 프리뷰용 테스트 데이터 설정
            UserPreferences.shared.setTeamName("롯데 자이언츠")
            UserPreferences.shared.updateLocalWinRate(isWin: true)
            UserPreferences.shared.updateLocalWinRate(isWin: true)
            UserPreferences.shared.updateLocalWinRate(isWin: false)
        }
}
