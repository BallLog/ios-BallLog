//
//  BallLogCardContentView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI

struct BallLogCardContentView: View {
    // API로 받아올 데이터들
    let title_api: String
    let matchDate: String  // "2025-03-04THH:MM:SS"
    let scoreCheering: Int
    let scoreOpposing: Int
    let cheeringTeamId: Int // 응원팀 아이디
    let opposingTeamId: Int // 상대팀 아이디
    let photos_api: [(imgUrl: String, sequence: Int)] // 사진 URL들
    let content_api: String  // 본문
    let winRate_api: Double  // 0.7 = 70%
    let stadiumId: Int  // 구장 아이디
    
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
                        .foregroundStyle(teamThemeBgColor(for: UserPreferences.shared.getTeamName()).shapeStyle)
                )
            }
            .padding(14)
        }
        .background(Color.white)
        .padding(1)
    }
    
    // MARK: - 섹션들
    
    private var titleSection: some View {
        Text(title_api.isEmpty ? "오늘의 승리요정!" : title_api)
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
            
            DotLineView(myTeam: UserPreferences.shared.getTeamName(), theme: 0)
            
            HStack {
                teamsView
                Spacer()
            }
            .padding(.horizontal, 14.0)
            .padding(.vertical, 14.0)
            .background(Color.white)
        }
    }
    
    func convertDateFormat(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return dateString // 변환 실패시 원본 반환
    }
    
    private var gameDateView: some View {
        HStack(spacing: 4) {
            Text(convertDateFormat(matchDate))
                .font(.system(size: 14))
                .bold()
            Image("under_triangle")
        }
        .foregroundStyle(teamFontColor)
    }
    
    private var scoreView: some View {
        HStack(spacing: 4) {
            Text("\(scoreCheering)")
                .bold()
            Text(":")
                .bold()
            Text("\(scoreOpposing)")
                .bold()
            Image("under_triangle")
        }
        .foregroundStyle(teamFontColor)
    }
    
    private var teamsView: some View {
        HStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(TeamSelectViewModel.findTeamById(cheeringTeamId)?.name ?? "팀 없음")
                    .bold()
                Image("under_triangle")
            }
            Text("vs")
            HStack(spacing: 4) {
                Text(TeamSelectViewModel.findTeamById(opposingTeamId)?.name ?? "팀 없음")
                    .bold()
                Image("under_triangle")
            }
        }
        .foregroundStyle(teamFontColor)
        .font(.system(size: 14))
    }
    
    private var photoSection: some View {
        VStack(spacing: 0) {
            DotLineView(myTeam: UserPreferences.shared.getTeamName(), theme: 0)
            
            if photos_api.count == 0 {
                // 기본 로고 이미지
                VStack {
                    Image("logo_title")
                        .foregroundStyle(teamThemeBgColor(for: UserPreferences.shared.getTeamName()).shapeStyle)
                }
                .frame(height: 175)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            } else {
                // 실제 사진들
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(photos_api, id: \.sequence) { photoURL in
                            AsyncImage(url: URL(string: photoURL.imgUrl)) { image in
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
            
            DotLineView(myTeam: UserPreferences.shared.getTeamName(), theme: 0)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading) {
            Text(content_api)
                .font(.custom("OwnglyphEuiyeonChae", size: 20))
                .fontWeight(.medium)
                .lineLimit(nil)
            Spacer(minLength: 0)
        }
        .foregroundStyle(teamFontColor)
        .frame(minHeight: 173)
        .frame(maxWidth: .infinity)
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
            Text("직관 승률 \(Int(winRate_api * 100))%")
                .font(.custom("Pretendard Variable", size: 12))
                .fontWeight(.medium)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(teamFontColor, lineWidth: 1)
                        .frame(height: 6)
                    Rectangle()
                        .fill(teamFontColor)
                        .frame(width: geometry.size.width * winRate_api, height: 6)
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
            Text(TeamSelectViewModel.getStadiumName(by: stadiumId))
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
    
    private var teamColor: Color {
        teamMainColor(for: UserPreferences.shared.getTeamName())
    }
    private var teamFontColor: Color {
        teamThemeFontColor(for: UserPreferences.shared.getTeamName())
    }
}

