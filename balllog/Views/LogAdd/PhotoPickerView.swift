//
//  PhotoPickerView.swift
//  balllog
//
//  Created by 전은혜 on 3/2/25.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedItems: [PhotosPickerItem]  // 부모 뷰에서 전달된 선택된 이미지 아이템들
    @State private var selectedImagesData: [Data] = []  // 선택된 이미지 데이터를 저장
    @State private var selectedIndex: Int = 0
    @State private var isLoading: Bool = false // 로딩 상태 추가

    var body: some View {
        ZStack() {
            if selectedImagesData.isEmpty {
                // 사진 선택 버튼 (갤러리 접근)
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 4,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    VStack(alignment: .center, spacing: 6.0) {
                        Image("add")
                            .frame(width: 26, height: 26)
                        Text("이미지 업로드")
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                        
                        // 로딩 표시 추가
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .frame(height: 219)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("gray_50"))
                    .background(Color("gray_20"))
                }
                .onChange(of: selectedItems) { _, newItems in
                    print("📸 선택된 아이템 변경: \(newItems.count)개")
                    loadImages(from: newItems)
                }
            } else {
                TabView(selection: $selectedIndex) {
                    ForEach(selectedImagesData.indices, id: \.self) { index in
                        if let uiImage = UIImage(data: selectedImagesData[index]) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 219)
                                .tag(index)
                                .clipped()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 219)
            }
                
            
            if !selectedImagesData.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            deleteCurrentImage()
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color("gray_90"))
                                Image("trash")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(Color.white)
                            }
                        }
                        Spacer()
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 4,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            ZStack {
                                Circle()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color("gray_90"))
                                Image("add_picture")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .onChange(of: selectedItems) { _, newItems in
                            print("📸 추가 아이템 변경: \(newItems.count)개")
                            loadImages(from: newItems)
                        }
                    }
                    .padding(.vertical, 6.0)
                    .padding(.horizontal, 9.0)
                }
                .zIndex(500)
            }
            // 로딩 오버레이
            if isLoading {
                Color.black.opacity(0.3)
                    .frame(height: 219)
                    .frame(maxWidth: .infinity)
                VStack {
                    ProgressView()
                    Text("이미지 로딩 중...")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(height: 219)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Private Methods
        
    private func loadImages(from items: [PhotosPickerItem]) {
        guard !items.isEmpty else {
            print("📸 아이템이 없음")
            selectedImagesData.removeAll()
            selectedIndex = 0
            return
        }
        
        isLoading = true
        
        Task {
            var newData: [Data] = []
            
            for (index, item) in items.enumerated() {
                print("📸 이미지 \(index + 1) 로딩 시작...")
                
                do {
                    // Data 타입으로 로드
                    if let data = try await item.loadTransferable(type: Data.self) {
                        print("✅ 이미지 \(index + 1) 로딩 성공: \(data.count) bytes")
                        newData.append(data)
                    } else {
                        print("❌ 이미지 \(index + 1) 로딩 실패: 데이터가 nil")
                    }
                } catch {
                    print("❌ 이미지 \(index + 1) 로딩 에러: \(error)")
                }
            }
            
            // 메인 스레드에서 UI 업데이트
            await MainActor.run {
                self.selectedImagesData = newData
                self.selectedIndex = 0
                self.isLoading = false
                
                print("📸 최종 로딩된 이미지: \(newData.count)개")
                print("📸 UI 상태 - isEmpty: \(selectedImagesData.isEmpty)")
            }
        }
    }
    
    private func deleteCurrentImage() {
//        guard selectedIndex < selectedImagesData.count && selectedIndex < selectedItems.count else {
//            return
//        }
//        
//        print("🗑 이미지 \(selectedIndex) 삭제")
//        
//        selectedImagesData.remove(at: selectedIndex)
//        selectedItems.remove(at: selectedIndex)
//        
//        // 인덱스 조정
//        if selectedIndex >= selectedImagesData.count && selectedImagesData.count > 0 {
//            selectedIndex = selectedImagesData.count - 1
//        } else if selectedImagesData.isEmpty {
//            selectedIndex = 0
//        }
//        
//        print("📸 삭제 후 이미지: \(selectedImagesData.count)개, 현재 인덱스: \(selectedIndex)")
        
        if selectedImagesData.indices.contains(selectedIndex) {
            selectedImagesData.remove(at: selectedIndex)
            selectedItems.remove(at: selectedIndex)
            selectedIndex = max(0, selectedIndex - 1)
        }
    }
    
}

struct PhotoPickerViewWrapper: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    
    // 테스트용 임시 이미지 데이터
    private var sampleImageData: [Data] {
        if let image = UIImage(systemName: "photo"),
           let data = image.jpegData(compressionQuality: 1.0) {
            return [data, data, data] // 여러 장 추가 가능
        }
        return []
    }

    var body: some View {
        PhotoPickerView(selectedItems: $selectedItems)
            .onAppear {
                // 프리뷰에서 selectedItems가 바뀌지 않으므로, 이미지 미리 보기를 위해 selectedImagesData를 프리뷰에서 강제 설정하고 싶다면,
                // 해당 값을 내부에서 처리하도록 수정이 필요함 (아래 참고)
            }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerViewWrapper()
    }
}
