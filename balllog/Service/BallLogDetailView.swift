//
//  BallLogDetail.swift
//  balllog
//
//  Created by 전은혜 on 3/20/25.
//

import SwiftUI

struct BallLogDetailView: View {
    @State private var theme: Int = 0
    @State private var myTeam: String = "GIANTS"

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Spacer().frame(minHeight: 8)
                        BallLogCard(theme: theme, myTeam: myTeam)
                        Spacer().frame(minHeight: 22)
                        ThemePicker(theme: $theme)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 73)
                    .navigationBarBackButtonHidden(true)
                }

                VStack {
                    DetailHeaderView(title: "볼로그")
                    Spacer()
                }
            }
        }
    }
}

struct BallLogCard: View {
    var theme: Int
    var myTeam: String

    var body: some View {
        ZStack {
            Image(theme == 0 ? "linecard" : "fillcard")
                .overlay(teamGradient(for: myTeam))
                .mask(
                    Image(theme == 0 ? "linecard" : "fillcard")
                        .resizable()
                )
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                
                VStack {
                    Text("제목이다~")
                        .font(.system(size: 12))
                        .foregroundStyle(theme == 0 ? teamMainColor(for: myTeam) : Color.white)
                }
                .padding(.horizontal, 20)
            
                VStack(alignment: .leading, spacing: 0) {

                    MatchInfoSection(myTeam: myTeam, theme: theme)

                    VStack(spacing: 0) {
                        DotLineView(myTeam: myTeam, theme: theme)
                        Rectangle().frame(height: 219)
                        DotLineView(myTeam: myTeam, theme: theme)
                    }

                    VStack(alignment: .leading) {
                        Text("직관 재밌었다~~!")
                            .font(.custom("Ownglyph brilliant", size: 16))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 124)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 14)

                    VStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(theme < 2 ? teamSubColor(for: myTeam) : Color.white)

                        WinRateView(myTeam: myTeam, theme: theme)
                            .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 16)
                }
                .background(theme == 1 ? Color.white : Color.clear)
                .foregroundStyle(theme < 2 ? teamMainColor(for: myTeam) : Color.white)
                .cornerRadius(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(theme < 2 ? AnyShapeStyle(teamGradient(for: myTeam)) : AnyShapeStyle(Color.white), lineWidth: 1.0)
                )
                .padding(.horizontal, 20)

                HStack {
                    Spacer()
                    Text("BALL-LOG")
                        .font(.custom("Playpen Sans", size: 12))
                        .foregroundStyle(theme == 0 ? teamSubColor(for: myTeam) : Color.white)
                        .fontWeight(.regular)
                        .lineSpacing(3)
                        .kerning(14)
                        .frame(maxHeight: .infinity, alignment: .center)
                }
                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }
}

struct MatchInfoSection: View {
    var myTeam: String
    var theme: Int

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("2025.04.01")
                    Spacer()
                    Text("잠실야구장")
                }.font(.system(size: 10))

                HStack {
                    HStack(spacing: 6) {
                        Text("롯데 자이언츠")
                        Text("vs").bold()
                        Text("두산 베어스")
                    }
                    Spacer()
                    HStack(spacing: 3) {
                        Text("0")
                        Text(":" ).bold()
                        Text("0")
                    }
                }.font(.system(size: 14))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
        }
    }
}

struct ThemePicker: View {
    @Binding var theme: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { index in
                Button(action: {
                    theme = index
                }) {
                    Rectangle()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(Color("gray_40"))
                        .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 2)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    BallLogDetailView()
}
