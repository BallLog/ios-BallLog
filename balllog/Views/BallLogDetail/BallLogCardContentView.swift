//
//  BallLogCardContentView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//


import SwiftUI

struct BallLogCardContentView: View {
    let displayData: BallLogDisplayData
    let teamName = UserPreferences.shared.getTeamName()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 14) {
                titleSection
                
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        gameInfoSection
                        photoSection
                        contentSection
                        bottomInfoSection
                    }
                    .padding(1)
                    .foregroundStyle(teamFontColor)
                }
                .background(
                    Rectangle()
                        .foregroundStyle(teamThemeBgColor(for: teamName).shapeStyle)
                )
            }
            .padding(14)
        }
        .background(Color.white)
        .padding(1)
    }
    
    // MARK: - 섹션들
    private var titleSection: some View {
        Text(displayData.title)
            .font(.system(size: 14))
            .foregroundStyle(teamFontColor)
            .bold()
    }
    
    private var gameInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                gameDateView
                Spacer()
                scoreView
            }
            .padding(.horizontal, 14.0)
            .padding(.vertical, 14.0)
            .background(Color.white)
            
            DotLineView(myTeam: teamName, theme: 0)
            
            HStack {
                teamsView
                Spacer()
            }
            .padding(.horizontal, 14.0)
            .padding(.vertical, 14.0)
            .background(Color.white)
        }
    }
    
    private var gameDateView: some View {
        HStack(spacing: 4) {
            Text(displayData.formattedDate)
                .font(.system(size: 14))
                .bold()
            Image("under_triangle")
        }
        .foregroundStyle(teamFontColor)
    }
    
    private var scoreView: some View {
        HStack(spacing: 4) {
            Text("\(displayData.scoreCheering)")
                .bold()
            Text(":")
                .bold()
            Text("\(displayData.scoreOpposing)")
                .bold()
            Image("under_triangle")
        }
        .foregroundStyle(teamFontColor)
    }
    
    private var teamsView: some View {
        HStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(displayData.cheeringTeamName)
                    .bold()
                Image("under_triangle")
            }
            Text("vs")
            HStack(spacing: 4) {
                Text(displayData.opposingTeamName)
                    .bold()
                Image("under_triangle")
            }
        }
        .foregroundStyle(teamFontColor)
        .font(.system(size: 14))
    }
    
    private var photoSection: some View {
        VStack(spacing: 0) {
            DotLineView(myTeam: teamName, theme: 0)
            
            if displayData.photos.isEmpty {
                // 기본 로고 이미지
                VStack {
                    Image("logo_title")
                        .foregroundStyle(teamThemeBgColor(for: teamName).shapeStyle)
                }
                .frame(height: 175)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            } else {
                // 실제 사진들
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(displayData.photos, id: \.sequence) { photo in
                            AsyncImage(url: URL(string: photo.imgUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 175)
                                    .frame(width: 311)
                                    .clipped()
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 175)
                                    .frame(width: 311)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                }
                .frame(height: 175)
                .background(Color.white)
            }
            
            DotLineView(myTeam: teamName, theme: 0)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading) {
            Text(displayData.content)
                .font(.custom("OwnglyphEuiyeonChae", size: 20))
                .fontWeight(.medium)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            Spacer(minLength: 0)
        }
        .foregroundStyle(teamFontColor)
        .frame(minHeight: 173, alignment: .topLeading)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, 14.0)
        .padding(.vertical, 10.0)
        .background(Color.white)
    }
    
    private var bottomInfoSection: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.clear)

            HStack(spacing: 0) {
                winRateSection
                
                Rectangle()
                    .frame(width: 1, height: 51)
                    .foregroundStyle(Color.clear)
                
                stadiumSection
            }
            .frame(height: 51)
        }
    }
    
    private var winRateSection: some View {
        VStack(alignment: .leading, spacing: 6.0) {
            // TODO: 승률 데이터 입력
            Text("직관 승률 \(Int(0.1 * 100))%")
                .font(.custom("Pretendard Variable", size: 12))
                .fontWeight(.bold)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(teamFontColor, lineWidth: 1)
                        .frame(height: 6)
                    Rectangle()
                        .fill(teamFontColor)
                    // TODO: 승률 데이터 입력
                        .frame(width: geometry.size.width * 0.1, height: 6)
                        .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    private var stadiumSection: some View {
        HStack(spacing: 4) {
            Text(displayData.stadiumName)
                .font(.system(size: 12))
                .bold()
            Image("under_triangle")
        }
        .padding(.horizontal, 14.0)
        .padding(.vertical, 18.0)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    // MARK: - 계산된 속성
    private var teamFontColor: Color {
        teamThemeFontColor(for: teamName)
    }
}
