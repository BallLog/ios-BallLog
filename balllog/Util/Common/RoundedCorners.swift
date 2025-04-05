//
//  RoundedCorners.swift
//  balllog
//
//  Created by 전은혜 on 3/20/25.
//

import SwiftUI

// Custom Shape: 왼쪽 위, 아래 모서리만 둥글게 처리
struct RoundedCorners: Shape {
    var tl: CGFloat // top-left corner radius
    var tr: CGFloat = 0 // top-right corner radius
    var bl: CGFloat // bottom-left corner radius
    var br: CGFloat = 0 // bottom-right corner radius

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + tl)) // 시작점
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bl)) // 왼쪽 아래로 선 그리기
        path.addQuadCurve(to: CGPoint(x: rect.minX + bl, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.maxY)) // 왼쪽 아래 둥글게
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // 오른쪽 아래로 선 그리기
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + tr)) // 오른쪽 위로 선 그리기
        path.addQuadCurve(to: CGPoint(x: rect.maxX - tr, y: rect.minY), control: CGPoint(x: rect.maxX, y: rect.minY)) // 오른쪽 위 둥글게
        path.addLine(to: CGPoint(x: rect.minX + tl, y: rect.minY)) // 왼쪽 위로 선 그리기
        path.closeSubpath() // 닫기

        return path
    }
}
