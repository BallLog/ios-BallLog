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
   
    var body: some View {
        HStack(spacing: 11) {
            // 사진 선택 버튼 (갤러리 접근)
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 4,
                matching: .images,
                photoLibrary: .shared()
            ) {
                VStack(alignment: .center, spacing: 2.0) {
                    Image("add")
                        .frame(width: 24, height: 24)
                    Text("이미지 업로드")
                        .font(.system(size: 16))
                }
                .frame(height: 219)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("gray_50"))
                .background(Color("gray_30"))
            }
            .onChange(of: selectedItems) { _, newItems in
                Task {
                    // 선택된 이미지들의 데이터를 가져와서 selectedImagesData에 저장
                    selectedImagesData = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            selectedImagesData.append(data)
                        }
                    }
                }
            }
            
            // 이미지 캐러셀
            if !selectedImagesData.isEmpty {
                TabView {
                    ForEach(selectedImagesData, id: \.self) { imageData in
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 219)  // 캐러셀 이미지의 높이
                                .padding()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 219)  // 캐러셀 높이 조정
                .padding()
            
            }
        }
    }
    
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        // selectedItems를 .constant([])로 전달하여 바인딩 값으로 사용
        PhotoPickerView(selectedItems: .constant([]))
    }
}
