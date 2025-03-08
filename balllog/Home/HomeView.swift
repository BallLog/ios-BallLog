//
//  HomeView.swift
//  balllog
//
//  Created by 전은혜 on 10/28/24.
//

import SwiftUI

struct HomeView: View {
    var data = false;
    var shouldNavigate = false;
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("나의 볼로그")
                            .fontWeight(.bold)
                            .foregroundColor(Color("gray_90"))
                        Spacer()
                        HStack(spacing: 6) {
                            Text("전체")
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                            Image(systemName: "chevron.down")
                                .frame(width: 16, height: 16)
                        }
                        .foregroundColor(Color("gray_50"))
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 28)
                    if data {
                        ScrollView {
                            VStack {
                                Text("LIST DATA!")
                            }
                            .frame(height: .infinity)
                            .navigationBarBackButtonHidden(true)
                        }
                    } else {
                        VStack {
                            Spacer()
                            NavigationLink(destination: LogAddView())  {
                                VStack(spacing: 6) {
                                    VStack(spacing: 2) {
                                        Image("log_add_gray")
                                        Text("볼로그 추가")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("gray_60"))
                                    }
                                    Text("나의 직관일기를 추가해주세요!")
                                        .fontWeight(.light)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color("gray_60"))
                                }
                                .frame(width: 227, height: 280)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.1), radius: 10.3, x: 0, y: 0)
                            }
                            Spacer()
                            Spacer()
                        }
                    }
                }
                VStack {
                    Spacer()
                    ZStack(alignment: .top) {
                        Image("menu_bg")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .shadow(color: Color(red: 98/255, green: 98/255, blue: 98/255, opacity: 0.25), radius: 4, x: 0, y: -2)
                        
                        HStack(alignment: .bottom) {
                            NavigationLink(destination: HomeView())  {
                                VStack(spacing: 4){
                                    Image("home")
                                    Text("홈")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color("gray_60"))
                                }
                                .frame(width: 76, height: 49)
                            }
                            Spacer()
                            NavigationLink(destination: LogAddView())  {
                                VStack(spacing: 6){
                                    Image("log_add")
                                    Text("볼로그")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color("gray_60"))
                                }
                                .frame(width: 76, height: 68)
                            }
                            Spacer()
                            NavigationLink(destination: MyPageView())  {
                                VStack(spacing: 4){
                                    Image("mypage")
                                    Text("마이페이지")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color("gray_60"))
                                }
                                .frame(width: 76, height: 49)
                            }
                        }
                        .padding(.horizontal, 24.0)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
