//
//  CloseSheetButton.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/23.
//

import SwiftUI

struct CloseSheetButton: View {
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    
    var body: some View {
        Section{
            GeometryReader{ geometryProxy in
                HStack {
                    Image(systemName: "xmark")
                    VStack(alignment: .leading) {
                        Text("关闭")
                        Text("点按两下结束阅读")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    Spacer()
                    Text("0")
                        .font(.body.bold())
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
