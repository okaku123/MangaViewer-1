//
//  NewCropView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/13.
//

import SwiftUI
import NukeUI
import UIKit
import Foundation
import PositionScrollView

struct NewCropView: View {
    //    @Binding var showPreview  : Bool
    @State var image : UIImage
    @Binding var cropType : CropSide
    
    @Binding var cropLeftA  : CGFloat
    @Binding var cropWidthA : CGFloat
    
    @Binding var cropLeftB : CGFloat
    @Binding var cropWidthB : CGFloat
    
    @Binding var isSaveA : Bool
    @Binding var isSaveB : Bool
    
    
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
                    Image(uiImage: image)
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
                
                //                VStack{
                //                    Spacer()
                //                    HStack{
                //                        Button( cropType == .A ? "B面" : "A面"){
                //                            if cropType == .A {
                //                                cropType = .B
                //                            }else{
                //                                cropType = .A
                //                            }
                //                        }
                //                        Spacer()
                //                        Button("保存"){
                //
                //                            let vb = geo.size.width * 0.8
                //                            let imgW = geo.size.width * imageScale
                //                            let lvb = vb / 2
                //                            if imageHOffset > 0 {
                //                                let offsetLeft = lvb + imageHOffset
                //                                let realOffset = ( imgW / 2 ) - offsetLeft
                //                                let leftOffset = realOffset / imgW
                //                                print( leftOffset )
                //                            }
                //
                //                            if imageHOffset < 0 {
                //                                let r = imgW / 2 - lvb
                //                                let leftOffset =  ( r - imageHOffset ) / imgW
                //                                print(leftOffset)
                //                            }
                //                        }
                //                    }
                //                    .padding()
                //                }
                //                .frame(width: geo.size.width)
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
            
            .onChange(of: isSaveA ){ isSaveA in
                if isSaveA {

                    let vb = geo.size.width * 0.8
                    let imgW = geo.size.width * imageScale
                    let lvb = vb / 2
                    
                    let widthScale =  vb / imgW
                    print("widthScale:\(widthScale)")
                    cropWidthA = widthScale
                    
                    var leftOffset : CGFloat = 0
                    
                    if imageHOffset > 0 {
                        let offsetLeft = lvb + imageHOffset
                        let realOffset = ( imgW / 2 ) - offsetLeft
                        leftOffset = realOffset / imgW
                    }
                    
                    if imageHOffset < 0 {
                        let r = imgW / 2 - lvb
                        leftOffset =  ( r - imageHOffset ) / imgW
                    }
                    
                    cropLeftA = leftOffset
                    
                    print("cropLeftA:\(cropLeftA) cropWidthA:\(cropWidthA)")
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                    self.isSaveA = false
                }
                
            }
            
        }
    }
}


struct NewCropViewPreviews: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
//    @State var image = UIImage(named: "test")

    @Binding var image : UIImage?

    @State var cropType : CropSide = .A
    
    @State var cropLeftA  : CGFloat = 0
    @State var cropWidthA : CGFloat = 1
    
    @State var cropLeftB : CGFloat = 0
    @State var cropWidthB : CGFloat = 1
    
    @State var isSaveA = false
    @State var isSaveB = false
    
    var body: some View{
        NavigationView {
            NewCropView(image: image!  ,
                        cropType: $cropType,
                        cropLeftA:$cropLeftA,
                        cropWidthA: $cropWidthA,
                        cropLeftB: $cropLeftB,
                        cropWidthB: $cropWidthB,
                        isSaveA: $isSaveA,
                        isSaveB: $isSaveB)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    leading:
                      
                    Button("取消"){
              
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    ,
                    trailing:
                        HStack(spacing : 25){
                        Button("A面确定"){
                            isSaveA = true
                            cropType = .B
                            
                    }
                        Button("B面确定"){
                            isSaveB = true
                    }
                    
                    Button("完成"){
                       
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }
                )
        }
//        .navigationViewStyle(.stack)
        .environment(\.colorScheme, .dark)
    }
}


//struct NewCropView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewCropViewPreviews()
//    }
//}
