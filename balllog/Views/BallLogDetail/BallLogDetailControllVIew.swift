//
//  BallLogDetailControllVIew.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//


import SwiftUI

struct BallLogDetailControlView: View {
    @ObservedObject var viewModel: BallLogDetailViewModel
    @Binding var showShareView: Bool
    @Binding var showEditView: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 22) {
                HStack(spacing: 14) {
                    shareButton
                    deleteButton
                }
                editButton
            }
            .padding(.vertical, 12.0)
            .padding(.horizontal, 20.0)
            .frame(height: 73.0)
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("gray_30")),
            alignment: .top
        )
    }
    
    private var shareButton: some View {
        VStack(spacing: -1) {
            Image("share")
                .resizable()
                .frame(width: 24, height: 24)
            Text("공유")
                .font(.system(size: 12))
                .bold()
        }
        .frame(width: 45, height: 45)
        .onTapGesture {
            showShareView = true
        }
    }
    
    private var deleteButton: some View {
        VStack(spacing: -1) {
            Image("delete")
                .resizable()
                .frame(width: 24, height: 24)
            Text("삭제")
                .font(.system(size: 12))
                .bold()
        }
        .frame(width: 45, height: 45)
        .onTapGesture {
            viewModel.showDeleteConfirmation = true
        }
    }
    
    private var editButton: some View {
        VStack {
            Button("수정하기") {
                showEditView = true
            }
            .buttonStyle(RoundedButtonStyle())
            .modifier(DefaultButtonWidth(width: .infinity))
        }
        .frame(height: 50.0)
    }
}
