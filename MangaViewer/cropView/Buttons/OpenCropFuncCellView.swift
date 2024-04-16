//
//  OpenCropFuncCellView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/10.
//

import SwiftUI

struct OpenCropFuncCellView: View {
    
    @State var cropPage = false
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    @Binding var focus : Bool

    
    var body: some View {
//        GeometryReader{ geometryProxy in
        Section{
            GeometryReader{ geometryProxy in
                HStack {
                       Image(systemName: "square.dashed")
                       VStack(alignment: .leading) {
                           Text("开启分页")
                           Text("将宽的页面分为两页")
                               .font(.caption2)
                               .opacity(0.7)
                       }
                        Spacer()
                        Toggle(isOn: $cropPage ){
                                Spacer()
                    }
                }
                .if( selectedTab == title ){ view in
                    view.foregroundColor(.blue)
                }
                .onChange(of: focus ){ focus in
                    selectedTab == title ? ( withAnimation{ cropPage = focus } ) : ()
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
//        }
    }
} 



struct OpenCropFuncCellView_Preview : PreviewProvider {
    
    @State static var title = "0"
    @State static var selectedTab = "0"
    @Namespace static var animation
    @State static var focus = true
    
    static var previews: some View {
        Form {
        OpenCropFuncCellView(title: "0",
                             selectedTab : $selectedTab ,
                             animation : animation ,
                             focus: $focus)
            
        }
    }
}
