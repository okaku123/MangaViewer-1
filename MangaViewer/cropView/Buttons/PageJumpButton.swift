//
//  PageJumpButton.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/22.
//

import SwiftUI

struct PageJumpButton: View {
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    @Binding var jumpCount : Int
    @State var currentCount : Int = 0
    
    var body: some View {
        
        Section{
            GeometryReader{ geometryProxy in
                HStack {
                    Image(systemName: "arrow.left.arrow.right")
                    VStack(alignment: .leading) {
                        Text("快进快退")
                        Text("左右滑动来快进快退页数")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    Spacer()
                    Stepper(value: $currentCount , in: -10...10, label: { Text("") })
                }
                .if( selectedTab == title ){ view in
                    view.foregroundColor(.blue)
                }
            }
        }
        .background(
            ZStack{
                if selectedTab == title {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor , lineWidth: 2 )
                        .padding(.leading, -10)
                        .padding(.trailing, -10)
                        .padding(.top, -3)
                        .padding(.bottom, -3)
                        .opacity(selectedTab == title ? 1 : 0)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                }
            }
        )
        
      
    }
}


