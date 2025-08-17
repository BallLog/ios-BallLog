//
//  HeaderView.swift
//  balllog
//
//  Created by 전은혜 on 6/25/25.
//

import SwiftUI

enum FilterOption: String, CaseIterable {
    case all = "전체"
    case winOnly = "승리한 직관만"
    
    var displayName: String {
        return self.rawValue
    }
}

struct HeaderView: View {
    @State private var selectedFilter: FilterOption = .all
    @State private var isDropdownOpen = false
    
    // 필터 변경을 부모 뷰에 알리기 위한 클로저
    var onFilterChanged: ((FilterOption) -> Void)?
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("나의 볼로그")
                    .fontWeight(.bold)
                    .foregroundColor(Color("gray_90"))
                Spacer()
                CustomDropdown(
                    selectedOption: $selectedFilter,
                    isOpen: $isDropdownOpen,
                    onSelectionChanged: { newFilter in
                        onFilterChanged?(newFilter)
                    }
                )
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 28)
            Spacer()
        }
    }
}



struct CustomDropdown: View {
    @Binding var selectedOption: FilterOption
    @Binding var isOpen: Bool
    let onSelectionChanged: (FilterOption) -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            // 드롭다운 버튼
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOpen.toggle()
                }
            }) {
                Spacer()
                HStack(spacing: 6) {
                    Text(selectedOption.displayName)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                    
                    ZStack {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .rotationEffect(.degrees(isOpen ? 180 : 0))
                            .animation(.easeInOut(duration: 0.2), value: isOpen)
                    }
                    .frame(width: 16, height: 16)
                }
                .padding(.vertical, 8.0)
                .padding(.horizontal, 4.0)
                .foregroundColor(Color("gray_50"))

            }
            .frame(width: 124)
            .background(Color.white)
            
            // 드롭다운 메뉴
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedOption = option
                                isOpen = false
                                onSelectionChanged(option)
                            }
                        }) {
                            HStack {
                                Text(option.displayName)
                                    .font(.system(size: 14))
                                    .foregroundColor(selectedOption == option ? Color("bc_02_60") : Color("gray_70"))
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(selectedOption == option ? Color("bc_02_05") : Color.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if option != FilterOption.allCases.last {
                            Divider()
                                .background(Color("gray_20"))
                        }
                    }
                }
                .frame(width: 124)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 0)
                .padding(.top, 6)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                    removal: .scale(scale: 0.95).combined(with: .opacity)
                ))
                .zIndex(1000) // 다른 요소들 위에 표시
            }
        }
        .frame(minWidth: 124) // 최소 너비 설정
    }
}


#Preview {
    HomeView(serviceVM: ServiceViewModel())
}
