//
//  ShareLogView.swift
//  balllog
//
//  Created by 전은혜 on 8/17/25.
//

import SwiftUI

struct ShareLogView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: BallLogDetailViewModel
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    @State private var selectedTheme = 0
    @State private var themeImages: [UIImage] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // 공유 이미지 미리보기
                    VStack(alignment: .leading, spacing: 0) {
                        if viewModel.isLoading {
                            loadingView
                        } else if viewModel.displayData != nil {
                            if let image = shareImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .scaleEffect(0.9)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 375, alignment: .top)
                                    .clipped()
                            }
                        } else {
                            emptyStateView
                        }
                    }
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .frame(height: 375)
                    .background(Color("gray_30"))
                    
                    ShareThemeSelectView(
                        selectedTheme: $selectedTheme,
                        themeImages: themeImages,
                        onThemeSelected: { _ in
                            updateShareImageForSelectedTheme()
                        }
                    )
                    Spacer()
                }
                
                // 고정 헤더
                VStack {
                    DetailHeaderView(
                        title: "공유하기",
                        customDismissAction: {
                            dismiss()
                        }
                    )
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Button("공유하기") {
                        if shareImage != nil {
                            showShareSheet = true
                        }
                    }
                    .buttonStyle(CustomButtonStyle())
                    .modifier(DefaultButtonWidth())
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("공유하기 화면 등장!")
            if let displayData = viewModel.displayData {
                print("displaydata ok~~")
                generateAllThemeImages(displayData: displayData)
            }
        }
        .onChange(of: viewModel.displayData) { _, displayData in
            if let displayData = displayData {
                print("displaydata change~~")
                generateShareImage(displayData: displayData)
            }
        }
        .onChange(of: selectedTheme) { _, _ in
            print("theme change~~")
            updateShareImageForSelectedTheme()
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(activityItems: [image])
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView("로딩 중...")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack {
            Text("볼로그를 불러올 수 없습니다")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    init(viewModel: BallLogDetailViewModel) {
        self.viewModel = viewModel
    }
    
    private func generateAllThemeImages(displayData: BallLogDisplayData) {
        print("🖼️ 모든 테마 이미지 생성 시작...")
        
        var generatedImages: [UIImage] = []
        
        for theme in 0..<3 {
            let cardView = createThemedCardView(displayData: displayData, theme: theme)
            let renderer = ImageRenderer(content: cardView)
            renderer.scale = 3.0
            
            if let image = renderer.uiImage {
                generatedImages.append(image)
                print("✅ 테마 \(theme + 1) 이미지 생성 성공!")
            } else {
                print("❌ 테마 \(theme + 1) 이미지 생성 실패")
            }
        }
        
        DispatchQueue.main.async {
            self.themeImages = generatedImages
            self.updateShareImageForSelectedTheme()
        }
    }
    
    private func updateShareImageForSelectedTheme() {
        if selectedTheme < themeImages.count {
            shareImage = themeImages[selectedTheme]
            print("✅ 테마 \(selectedTheme + 1) 이미지로 업데이트!")
        }
    }
    
    private func generateShareImage(displayData: BallLogDisplayData) {
        print("🖼️ 이미지 생성 시작...")
        
        // 선택된 테마에 따라 다른 스타일의 카드뷰 생성 (추후 구현 예정)
        let cardView = createThemedCardView(displayData: displayData, theme: selectedTheme)
        let renderer = ImageRenderer(content: cardView)
        
        // 이미지 크기 설정
        renderer.scale = 3.0
        
        // 동기적으로 이미지 생성
        if let image = renderer.uiImage {
            DispatchQueue.main.async {
                print("✅ 이미지 생성 성공!")
                self.shareImage = image
            }
        } else {
            print("❌ 이미지 생성 실패")
        }
    }
    
    private func createThemedCardView(displayData: BallLogDisplayData, theme: Int) -> some View {
        // 현재는 기본 카드뷰만 반환, 추후 테마별로 다른 뷰 반환 예정
        return BallLogCardOnlyView(displayData: displayData, theme: theme)
            .frame(width: 341, height: 590)
            .background(Color.white)
    }
}
