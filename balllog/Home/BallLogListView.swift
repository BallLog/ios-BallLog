//
//  BallLogListView.swift
//  balllog
//
//  Created by 전은혜 on 6/25/25.
//


import SwiftUI

// 샘플 데이터
let sampleCards = [
    CardItem(title: "Primary Card", content: "메인 카드 내용입니다.", isPrimary: true),
    CardItem(title: "Sub Card 1", content: "첫 번째 서브 카드입니다.", isPrimary: false),
    CardItem(title: "Sub Card 2", content: "두 번째 서브 카드입니다.", isPrimary: false),
    CardItem(title: "Sub Card 3", content: "세 번째 서브 카드입니다.", isPrimary: false),
    CardItem(title: "Sub Card 4", content: "네 번째 서브 카드입니다.", isPrimary: false)
]

struct BallLogListView: View {
    @Binding var selectedCard: CardItem?
    @Binding var showLogAdd: Bool

    var data = false;
    var shouldNavigate = false;
    
    var body: some View {
        VStack(alignment: .center) {
            if !data {
                ScrollView {
                    VStack(spacing: 20.0){
                        ForEach(sampleCards) { card in
                            Group {
                                if card.isPrimary {
                                    PrimaryCardView()
                                } else {
                                    SubCardView()
                                }
                            }
                            .onTapGesture {
                                selectedCard = card
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                VStack {
                    Spacer()
                    AddBallLogView(showLogAdd: $showLogAdd)
                    Spacer()
                    Spacer()
                }
            }
        }
        .padding(.top, 60)
    }
}
