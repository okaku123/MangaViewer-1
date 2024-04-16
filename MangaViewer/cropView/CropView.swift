//
//  CropView.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/1.
//

import SwiftUI
import NukeUI
import UIKit
import Foundation
import PositionScrollView

enum CropSide {
    case A
    case B
}

struct CropView: View {
    
//    @Binding var showPreview  : Bool
    @State var cropType : CropSide = .A

    @State var imageVOffset : CGFloat = 0
    @ObservedObject var myViewVModel = PositionScrollViewModel(pageSize: CGSize(width: 30, height: 10),
                                                              verticalScroll : Scroll(scrollSetting: ScrollSetting(pageCount: 60, initialPage: 30 , unitCountInPage: 1, afterMoveType: .fitToNearestUnit , scrollSpeedToDetect: 2 ), pageLength: 10)
        )
    @State var imageHOffset : CGFloat = 0
    @ObservedObject var myViewHModel = PositionScrollViewModel(pageSize: CGSize(width: 10, height: 30),
        horizontalScroll: Scroll(scrollSetting: ScrollSetting(pageCount: 60, initialPage: 30 , unitCountInPage: 1, afterMoveType: .fitToNearestUnit, scrollSpeedToDetect: 30), pageLength: 10),
        verticalScroll: nil)
    
    @State var imageScale : CGFloat = 1
    @State var slideScale : CGFloat = 0
    @ObservedObject var myViewSModel = PositionScrollViewModel(pageSize: CGSize(width: 10, height: 30),
        horizontalScroll: Scroll(scrollSetting: ScrollSetting(pageCount: 60, initialPage: 30 , unitCountInPage: 1, afterMoveType: .fitToNearestUnit, scrollSpeedToDetect: 30), pageLength: 10),
        verticalScroll: nil)
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .center ){
                VStack{
                    Image("test")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame( width: geo.size.width * imageScale)
                        .clipped()
                        .transformEffect(.init(translationX: imageHOffset, y: imageVOffset ))
                }.frame(width: geo.size.width )
                ZStack(alignment: .bottom ){
                    ZStack(alignment: .topLeading ){
                        Rectangle()
                            .stroke( cropType == .A ? Color.blue : Color.red , lineWidth: 2)
                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                        Label( cropType == .A ? "A面" : "B面" , systemImage: "crop")
                            .padding()
                    }
                    TransformVSideBar(value: $slideScale, myViewModel: myViewSModel)
                        .frame(width: 150)
                        .clipped()
                        .padding(.bottom, 0)
                }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                
                HStack{
                    Spacer()
                    TransformHSideBar(value: $imageVOffset  , myViewModel: myViewVModel)
                      
                }
                VStack{
                    Spacer()
                    TransformVSideBar(value: $imageHOffset, myViewModel: myViewHModel)
                    
                }
                .frame(height:geo.size.height)
                VStack{
                    Spacer()
                    HStack{
                        Button( cropType == .A ? "B面" : "A面"){
                            if cropType == .A {
                                cropType = .B
                            }else{
                                cropType = .A
                            }
                        }
                        Spacer()
                        Button("保存"){
                    
                            let vb = geo.size.width * 0.8
                            let imgW = geo.size.width * imageScale
                            let lvb = vb / 2
                            if imageHOffset > 0 {
                                let offsetLeft = lvb + imageHOffset
                                let realOffset = ( imgW / 2 ) - offsetLeft
                                let leftOffset = realOffset / imgW
                                print( leftOffset )
                            }
                            
                            if imageHOffset < 0 {
                               let r = imgW / 2 - lvb
                               let leftOffset =  ( r - imageHOffset ) / imgW
                                print(leftOffset)
                            }
                        }
                    }
                    .padding()
                }
                .frame(width: geo.size.width)
            }
       
            .frame(width: geo.size.width, height: geo.size.height)
            .ignoresSafeArea(.all)
            .background(Color.black)
            ///to do scale
            .onChange(of: slideScale , perform: { value in
                if slideScale > 0 {
                   imageScale = 1 + slideScale * 0.01
                } else if slideScale < 0 {
                    var _imageScale = 1 + slideScale * 0.01
                    if _imageScale < 0.3 {
                        _imageScale = 0.3
                    }
                    imageScale = _imageScale
                }
            })
        }
//        .overlay(
//            VStack{
//            swipeGesture{ direction in
//            if direction == .right {
//
//            }
//            if direction == .left {
//
//
//            }
//            if direction == .down {
//
//            }
//            if direction == .up{
//
//            }
//
//            if direction == .tap2 {
//
//            }
//
//            if direction == .tap1 {
//
//            }
//
//            if direction == .tap3 {
//
//            }
//
//            if direction == .circle {
//
//            }
//        }
//
//            TransformVSideBar(value: $slideScale, myViewModel: myViewSModel)
//                .frame(width: 150)
//                .clipped()
//                .padding(.bottom, 5)
//
//            TransformVSideBar(value: $imageHOffset, myViewModel: myViewHModel)
//                .foregroundColor(.white)
//
//        }.background(Color.black.opacity(0.8) )
//
//        )
        
    }
}


struct CropViewPreviews: View {
    @State var showPreview = false
    var body: some View{
        NavigationView {
//            CropView(showPreview: $showPreview )
            CropView()
                .navigationBarTitle("裁剪", displayMode: .inline)
                .navigationBarItems(
                        trailing:
                            Button(action: {
                                showPreview.toggle()
                            }) {
                                Label("设置", systemImage: "greetingcard.fill")
                                    .foregroundColor(.white)
                            }
                )
        }
//        .navigationViewStyle(.stack)
        .environment(\.colorScheme, .dark)
    }
}




struct CropView_Previews: PreviewProvider {
    
     @State  static var showPreview = false
    
    static var previews: some View {
        CropViewPreviews()


    }
}









//struct TransformSideBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TransformHSideBar(count: 57)
////        TransformVSideBar(count: 57)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//
//}

