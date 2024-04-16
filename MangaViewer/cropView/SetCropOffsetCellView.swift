//
//  SetCropOffsetCellView.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/11.
//

import SwiftUI

struct SetCropOffsetCellView: View {
    
    @State var cropPage = false
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    @Binding var focus : Bool
    @Binding var cropPageOffset : Int
    @State var handle = "NONE"
    
    var body: some View {
        
        GeometryReader{ geometryProxy in
          
            Section{
                    HStack {
                        Image(systemName: "arrow.right.to.line.compact")
                        VStack(alignment: .leading) {
                            Text("页面出血偏移 : \(cropPageOffset)")
                            Text("设置出血页的开始位置")
                                .font(.caption)
                                .opacity(0.8)
                        }
                        Stepper(value: $cropPageOffset , in: 0...10, label: { Text("") })
                    }
                    .onChange(of: handle , perform: { value in
                    if selectedTab == title {
                        switch handle {
                        case "UP":
                            cropPageOffset += 1
                            cropPageOffset > 9 ? (cropPageOffset = 9) : ()
                            break
                        case "DOWN":
                            cropPageOffset -= 1
                            cropPageOffset < 0 ? (cropPageOffset = 0) : ()
                            break
                        default:
                            break
                        }
                    }
                })
                    .if( selectedTab == title ){ view in
                        view.foregroundColor(.blue)
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
}

struct SetCropOffsetCellView_Previews: PreviewProvider {
    @State static var title = "0"
    @State static var selectedTab = "0"
    @Namespace static var animation
    @State static var focus = true
    @State static var cropPageOffset = 0
    
    static var previews: some View {
        Form {
            SetCropOffsetCellView(title: "0",
                             selectedTab : $selectedTab ,
                             animation : animation ,
                             focus: $focus,
                             cropPageOffset : $cropPageOffset)
            
        }
    }
}
