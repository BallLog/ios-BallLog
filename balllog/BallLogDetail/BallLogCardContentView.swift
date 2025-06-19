//
//  BallLogCardContentView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI

struct BallLogCardContentView: View {
    @EnvironmentObject var globalData: GlobalData
    
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
        VStack(alignment: .leading, spacing: 14) {
            titleSection
            
            VStack(alignment: .leading, spacing: 0) {
                gameInfoSection
                photoSection
                contentSection
                bottomInfoSection
            }
            .foregroundStyle(teamColor)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .stroke(teamColor, lineWidth: 1.0)
            )
            
            Spacer()
        }
        .padding(14)
    }
    
    // MARK: - 섹션들
    
    private var titleSection: some View {
        Text(title_api.isEmpty ? "오늘의 승리요정!" : title_api)
            .font(.system(size: 14))
            .foregroundStyle(teamColor)
            .bold()
            .padding(.top, 14)
    }
    
    private var gameInfoSection: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack {
                gameDateView
                Spacer()
                scoreView
            }
            .padding(.horizontal, 14.0)
            
            DotLineView(myTeam: globalData.myTeamKey, theme: 0)
                .padding(.vertical, 14.0)
            
            HStack {
                teamsView
                Spacer()
            }
            .padding(.horizontal, 14.0)
        }
        .foregroundStyle(teamColor)
        .padding(.vertical, 14.0)
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
                .foregroundStyle(teamColor)
        }
    }
    
    private var teamsView: some View {
        HStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(TeamData.shared.findIdTeam(by: cheeringTeamId)?.name ?? "팀 없음")
                    .bold()
                Image("under_triangle")
                    .foregroundStyle(teamColor)
            }
            Text("vs")
            HStack(spacing: 4) {
                Text(TeamData.shared.findIdTeam(by: opposingTeamId)?.name ?? "팀 없음")
                    .bold()
                Image("under_triangle")
                    .foregroundStyle(teamColor)
            }
        }
        .font(.system(size: 14))
    }
    
    private var photoSection: some View {
        VStack(spacing: 0) {
            DotLineView(myTeam: globalData.myTeamKey, theme: 0)
            
            if photos_api.count == 0 {
                // 기본 로고 이미지
                VStack {
                    Image("logo_title")
                        .foregroundStyle(teamColor)
                }
                .frame(height: 219)
                .frame(maxWidth: .infinity)
            } else {
                // 실제 사진들
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(photos_api, id: \.sequence) { photoURL in
                            AsyncImage(url: URL(string: photoURL.imgUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 219)
                                    .frame(width: 300)
                                    .clipped()
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 219)
                                    .frame(width: 300)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                }
                .frame(height: 219)
            }
            
            DotLineView(myTeam: globalData.myTeamKey, theme: 0)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading) {
            Text(content_api)
                .font(.custom("OwnglyphEuiyeonChae", size: 20))
                .foregroundStyle(teamColor)
                .fontWeight(.medium)
                .lineLimit(nil)
            Spacer(minLength: 0)
        }
        .frame(minHeight: 173)
        .padding(.horizontal, 14.0)
        .padding(.vertical, 10.0)
    }
    
    private var bottomInfoSection: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(teamColor)

            HStack(spacing: 0) {
                winRateSection
                
                Rectangle()
                    .frame(width: 1, height: 51)
                    .foregroundStyle(teamColor)
                
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
                        .strokeBorder(teamColor, lineWidth: 1)
                        .frame(height: 6)
                    Rectangle()
                        .fill(teamColor)
                        .frame(width: geometry.size.width * winRate_api, height: 6)
                        .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
                }
            }
            .frame(height: 6)
        }
        .foregroundStyle(teamColor)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }
    
    private var stadiumSection: some View {
        HStack(spacing: 4) {
            Text(StadiumData.shared.findNameOfStadium(by: stadiumId) ?? "--")
                .font(.system(size: 12))
                .bold()
            Image("under_triangle")
                .foregroundStyle(teamColor)
        }
        .padding(.horizontal, 14.0)
        .padding(.vertical, 12.0)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - 계산된 속성
    
    private var teamColor: Color {
        teamMainColor(for: globalData.selectedTeam?.key)
    }
}


#Preview {
    BallLogCardContentView(
        title_api: "오늘의 승리요정!",
        matchDate: "2025-03-04T17:00:00",
        scoreCheering: 3,
        scoreOpposing: 1,
        cheeringTeamId: 1,
        opposingTeamId: 3,
        photos_api: [], // 빈 배열이면 기본 로고 표시
        content_api: "오늘 오랜만에 직관 갔는데 승요했음~ 오늘 경기 진짜 잘했고 앞으로도 이렇게만 했으면 좋겠다",
        winRate_api: 0.7,
        stadiumId: 2
    )
    .environmentObject({
        let data = GlobalData.shared
        if let tigers = TeamData.shared.findIdTeam(by: 1) {
            data.setMyTeam(tigers)
        }
        return data
    }())
}
