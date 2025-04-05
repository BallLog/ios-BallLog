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
    @StateObject private var serviceVM = ServiceViewModel()

    var body: some View {
        ZStack {
            TabView(selection: $serviceVM.selectedTab) {
                Group {
                    HomeView()
                        .tag(ServiceViewModel.Tab.home)
                    MyPageView()
                        .tag(ServiceViewModel.Tab.mypage)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            VStack{
                Spacer()
                tabBar
            }
        }
        .interactiveDismissDisabled(true)
        .fullScreenCover(isPresented: $serviceVM.shouldPresentLogView) {
            LogAddView() // 로그 추가 페이지
        }
    }
    
    var tabBar: some View {
        ZStack(alignment: .top) {
            Image("TabBar")
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 74)

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
            .frame(maxWidth: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ServiceView()
}
