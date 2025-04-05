//
//  TermsOfUseView.swift
//  balllog
//
//  Created by 전은혜 on 4/5/25.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8.0){
                Text("서비스 이용약관")
                    .fontWeight(.semibold)
                    .font(.system(size: 14.0))
                VStack {
                    Text("제1조(목적) 이 약관은 볼로그팀(전자상거래 사업자)가 운영하는 볼로그(이하 “몰”이라 한다)에서 제공하는 인터넷 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리․의무 및 책임사항을 규정함을 목적으로 합니다.")
                        .fontWeight(.light)
                        .font(.system(size: 10.0))
                }
                // TODO: 이용약관
                Spacer()
            }
            .foregroundStyle(Color("gray_90"))
            .frame(maxWidth: .infinity)
            .padding(.top, 75.0)
            .padding([.leading, .bottom, .trailing], 20.0)
            VStack {
                // 헤더
                DetailHeaderView(title:"이용약관")
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TermsOfUseView()
}
