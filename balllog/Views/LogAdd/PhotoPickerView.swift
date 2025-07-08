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
                    }
                    .frame(height: 219)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("gray_50"))
                    .background(Color("gray_20"))
                }
                .onChange(of: selectedItems) { _, newItems in
                    Task {
                        // 선택된 이미지들의 데이터를 가져와서 selectedImagesData에 저장
                        var newData: [Data] = []
                        for item in newItems {
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                newData.append(data)
                            }
                        }
                        selectedImagesData = newData
                        selectedIndex = 0
                        print("Updated selectedImagesData: \(selectedImagesData.count) items")
                        print("Is empty? \(selectedImagesData.isEmpty)")
                    }
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
                            if selectedImagesData.indices.contains(selectedIndex) {
                                selectedImagesData.remove(at: selectedIndex)
                                selectedItems.remove(at: selectedIndex)
                                selectedIndex = max(0, selectedIndex - 1)
                            }
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
                            matching: .images
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
                            Task {
                                // 선택된 이미지들의 데이터를 가져와서 selectedImagesData에 저장
                                var newData: [Data] = []
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self) {
                                        newData.append(data)
                                    }
                                }
                                selectedImagesData = newData
                                selectedIndex = 0
                                print("Updated selectedImagesData: \(selectedImagesData.count) items")
                                print("Is empty? \(selectedImagesData.isEmpty)")
                            }
                        }
                    }
                    .padding(.vertical, 6.0)
                    .padding(.horizontal, 9.0)
                }
            }
        }
        .frame(height: 219)
        .frame(maxWidth: .infinity)
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
