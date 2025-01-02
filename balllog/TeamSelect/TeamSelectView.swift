//
//  TermsView.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import SwiftUI

struct TeamSelectView: View {
    @StateObject private var termsViewModel: TermsViewModel
    let teamList = [["삼성 라이온즈", "롯데 자이언츠"], ["SSG 랜더스", "KIA 타이거즈"], ["LG 트윈스", "두산 베어스"], ["한화 이글스", "키움 히어로즈"], ["KT 위즈", "NC 다이노스"]]
    
    init(termsViewModel: TermsViewModel = TermsViewModel()) {
        _termsViewModel = StateObject(wrappedValue: termsViewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24.0) {
                VStack(alignment: .leading, spacing: 4.0) {
                    Text("응원구단 선택")
                        .bold()
                        .font(.system(size: 24))
                        .lineSpacing(36)
                    Text("내가 응원하는 구단을 선택 해주세요")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .lineSpacing(21)
                }
                .padding(.horizontal, 30.0)
                VStack(alignment: .center, spacing: 30) {
                    HStack (spacing: 15) {
                        Button("삼성 라이온즈") {
                            print("삼라")
                        }
                        .buttonStyle(TeamButtonStyle())
                        Button("롯데 자이언츠") {
                            print("롯자")
                        }
                        .buttonStyle(TeamButtonStyle())
                    }
                    HStack (spacing: 15) {
                        Button("SSG 랜더스") {
                            print("쓱")
                        }
                        .buttonStyle(TeamButtonStyle())
                        Button("KIA 타이거즈") {
                            print("갸")
                        }
                        .buttonStyle(TeamButtonStyle())
                    }
                    HStack (spacing: 15) {
                        Button("LG 트윈스") {
                            print("엘지")
                        }
                        .buttonStyle(TeamButtonStyle())
                        Button("두산 베어스") {
                            print("두베")
                        }
                        .buttonStyle(TeamButtonStyle())
                    }
                    HStack (spacing: 15) {
                        Button("한화 이글스") {
                            print("한화")
                        }
                        .buttonStyle(TeamButtonStyle())
                        Button("키움 히어로즈") {
                            print("키움")
                        }
                        .buttonStyle(TeamButtonStyle())
                    }
                    HStack (spacing: 15) {
                        Button("KT 위즈") {
                            print("킅")
                        }
                        .buttonStyle(TeamButtonStyle())
                        Button("NC 다이노스") {
                            print("엔씨")
                        }
                        .buttonStyle(TeamButtonStyle())
                    }
                }
                .frame(width: .infinity)
                .padding(.horizontal, 20.0)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            .padding(.top, 56.0)
            Spacer()
            VStack {
                 
            }
            .navigationDestination(isPresented: $termsViewModel.shouldNavigate) {
                HomeView()
            }
            .padding(.bottom, 16.0)
        }
    }
}

#Preview {
    TeamSelectView()
}
