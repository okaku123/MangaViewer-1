//
//  HUD.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/8/14.
//

import Foundation
import SwiftUI
import UIKit

struct HUD: View {
    
//   @State var dismissHandler : ((Bool) -> Void)? = nil
    
    @Binding var title : String
    
    @ViewBuilder var body: some View {
        Text("\(title)")
            .foregroundColor(.gray)
            .padding(.horizontal, 10)
            .padding(14)
            .background(
                Blur(style: .systemMaterial)
                    .clipShape(Capsule())
                    .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
            )
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
