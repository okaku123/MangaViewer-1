//
//  LastReadButton.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/22.
//

import SwiftUI

struct LastReadButton: View {
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    
    var body: some View {
        Section{
            GeometryReader{ geometryProxy in
                HStack {
                    Image(systemName: "bookmark")
                    VStack(alignment: .leading) {
                        Text("上次阅读")
                        Text("跳转到上次离开的位置")
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

