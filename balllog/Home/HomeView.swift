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
                VStack(alignment: .center) {
                    if !data {
                        ScrollView {
                            VStack(spacing: 20.0){
                                PrimaryCardView()
                                SubCardView()
                                SubCardView()
                                SubCardView()
                                SubCardView()
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        VStack {
                            Spacer()
                            AddBallLogView()
                            Spacer()
                            Spacer()
                        }
                    }
                }
                .padding(.top, 60)
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
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
