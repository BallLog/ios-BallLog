//
//  PhotoPickerView.swift
//  balllog
//
//  Created by 전은혜 on 3/2/25.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedItems: [PhotosPickerItem] // 사용자가 선택한 사진
    @State private var selectedImages: [UIImage] = [] // 변환된 이미지 데이터
   
    var body: some View {
        HStack(spacing: 11) {
            // 사진 선택 버튼 (갤러리 접근)
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 4, matching: .images, photoLibrary: .shared()) {
                VStack(alignment: .center, spacing: 2.0) {
                    Image(systemName: "camera")
                        .frame(width: 24, height: 24)
                    HStack(alignment: .center, spacing: 0.0) {
                        Text("\(selectedItems.count)")
                            .fontWeight(.bold)
                        Text("/4")
                    }
                }
                .frame(width: 86, height: 86)
                .cornerRadius(4)
                .foregroundColor(Color("gray_50"))
                .background(Color("gray_20"))
            }
            .disabled(selectedImages.count >= 4)
            
            ScrollView(.horizontal, showsIndicators: false){
                // 미리보기
                HStack(spacing: 6) {
                    ForEach(Array(selectedImages.enumerated()), id: \.element) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 86, height: 86)
                                .cornerRadius(4)
                            
                            // X 버튼 (사진 삭제)
                            Button(action: {
                                removeImage(at: index)
                            }) {
                                Image("close")
                            }
                            .offset(x: 5, y: -5)
                        }
                        .frame(width: 95, height: 100)
                    }
                }
            }
        }
        .frame(height: 100.0)
        .task(id: selectedItems) { // 선택된 사진 변경될 때 실행
            await loadSelectedImages()
        }
    }
    
    // 선택한 사진을 이미지로 변환하는 함수
    func loadSelectedImages() async {
       var newImages: [UIImage] = []
       for item in selectedItems {
           if let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) {
               newImages.append(image)
           }
       }
       selectedImages = newImages
    }

    // 특정 이미지 삭제 함수
    func removeImage(at index: Int) {
       selectedImages.remove(at: index)
       selectedItems.remove(at: index)
    }

}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        // selectedItems를 .constant([])로 전달하여 바인딩 값으로 사용
        PhotoPickerView(selectedItems: .constant([]))
    }
}
