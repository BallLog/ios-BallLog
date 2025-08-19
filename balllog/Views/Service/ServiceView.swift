//
//  ServiceView.swift
//  balllog
//
//  Created by 전은혜 on 1/11/25.
//

import SwiftUI

enum NavigationDestination: String {
    case home
    case detail
    case edit
}

struct ServiceView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var serviceVM = ServiceViewModel()

    var body: some View {
        ZStack {
            TabView(selection: $serviceVM.selectedTab) {
                Group {
                    HomeView(serviceVM: serviceVM)
                        .tag(ServiceViewModel.Tab.home)
                    MyPageView(authViewModel: authViewModel, serviceVM: serviceVM)
                        .tag(ServiceViewModel.Tab.mypage)
                }
                .toolbar(.hidden, for: .tabBar)
            }

            if serviceVM.showTabBar {
                VStack{
                    Spacer()
                    tabBar
                }
                .background(Color.clear)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom) // 하단 안전 영역 무시
        .interactiveDismissDisabled(true)
        .fullScreenCover(isPresented: $serviceVM.shouldPresentLogView) {
            LogAddView(onSave: {
                // 볼로그 저장 후 홈뷰 데이터 리프레시 필요
                print("🔄 ServiceView: 볼로그 저장 완료, NotificationCenter로 알림 전송")
                NotificationCenter.default.post(name: NSNotification.Name("BallLogSaved"), object: nil)
            }) // 로그 추가 페이지
        }
        .animation(.easeInOut(duration: 0.3), value: serviceVM.showTabBar) // 탭바 표시/숨김 애니메이션
    }
    
    var tabBar: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                // 하얀색 박스
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 93)
                // 중앙 원형 버튼 배경
                VStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 50, height: 50)
                        .offset(y: 5)
                    Spacer()
                }
                .frame(height: 110)
            }
            .background(Color.clear)

            HStack(alignment: .bottom) {
                Spacer()
                Button {
                    serviceVM.selectedTab = .home
                } label: {
                    VStack(spacing: 4.0) {
                        Image("home")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24.0, height: 24.0)
                        Text("홈")
                            .font(.system(size:13))
                            .fontWeight(.medium)
                    }
                    .frame(width: 76, height: 49)
                    .foregroundColor(serviceVM.selectedTab == .home ? Color("bc_02_60") : Color("gray_60"))
                }
                Spacer()
                Button {
                    serviceVM.selectedTab = .add
                } label : {
                    VStack(spacing: 6.0) {
                        Image("log_add")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40.0, height: 40.0)
                            .foregroundColor(Color("gray_100"))
                        Text("볼로그")
                            .font(.system(size:13))
                            .fontWeight(.medium)
                            .foregroundColor(Color("gray_60"))
                    }
                    .frame(width: 76, height: 68)
                }
                Spacer()
                Button {
                    serviceVM.selectedTab = .mypage
                } label: {
                    VStack(spacing: 4.0) {
                        Image("mypage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24.0, height: 24.0)
                        Text("마이페이지")
                            .font(.system(size:13))
                            .fontWeight(.medium)
                    }
                    .frame(width: 76, height: 49)
                    .foregroundColor(serviceVM.selectedTab == .mypage ? Color("bc_02_60") : Color("gray_60"))
                }
                Spacer()
            }
            .padding(.top, 8.0)
            .background(Color.clear)
            .frame(maxWidth: .infinity)
        }
        .compositingGroup()
        .shadow(
            color: Color(red: 98/255, green: 98/255, blue: 98/255, opacity: 0.25),
            radius: 2,
            x: 0,
            y: -2
        )
        .clipped()
        .navigationBarBackButtonHidden(true)
    }
}

struct ServiceViewPreview: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ServiceView()
            .environmentObject(authViewModel)
            .onAppear {
                UserPreferences.shared.setTeamName("삼성 라이온즈")
            }
    }
}

#Preview {
    ServiceViewPreview()
}
