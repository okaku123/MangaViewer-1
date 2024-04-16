//
//  CustomCorners.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/6/25.
//

import SwiftUI

struct CustomCorners: Shape {
    var corners : UIRectCorner
    var radius : CGFloat
    func path(in rect: CGRect) -> Path {
        return Path( UIBezierPath(roundedRect: rect, byRoundingCorners: corners , cornerRadii: CGSize(width: radius, height: radius)).cgPath )
    }
   
}

