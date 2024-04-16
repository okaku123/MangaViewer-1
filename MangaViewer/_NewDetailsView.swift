//
//  DetailsView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Combine
import Foundation
import SwiftUI
import SDWebImageSwiftUI
import UIKit
import SwiftUIPager
import Alamofire



struct _NewDetailsView : View {
    // MARK: 阅读设置 -
    @AppStorage("isAnima") var isAnima: Bool = true
    @AppStorage("isScale") var isScale: Bool = true
    @AppStorage("isOpacity") var isOpacity: Bool = true
    @AppStorage("isRotation") var isRotation: Bool = true
    @AppStorage("isLoop") var isLoop: Bool = false
    @AppStorage("isRightToLeft") var isRightToLeft: Bool = false
    @AppStorage("isTopToBottom") var isTopToBottom: Bool = false

    
    let sheetStyle = PartialSheetStyle(background: .blur(.systemMaterialDark),
                                       handlerBarColor: Color(UIColor.systemGray2),
                                       enableCover: true,
                                       coverColor: Color.black.opacity(0.001) ,
                                       blurEffectStyle:  .systemChromeMaterial,
                                       cornerRadius: 10,
                                       minTopDistance: 110)
    
    @State var isSheetShown = false
    var name : String = ""
    @State var navBarHidden: Bool = false
    
    @State var imagesList : [ MangaPageObject ] = []
    @State var draggingList : [ Bool ] = []
    
    @State var showingSheet = false
    @State var currentPage : Int = 0
    @State var jumpPageCount : Int = -1
    @State var jumpToggle : Bool = false
    @State var totalPageCount = 2
    @ObservedObject var lastReadModel : LastReadModel = LastReadModel()
    
    //　更换uicollectview 为 swiftuipager
    @State var imagesScaleList : [ CGFloat ] = []
    @State var currentIndex = 0
    @GestureState var scale: CGFloat = 1.0
    @State private var page: Page = .first()
    // end
    
    //图片暗度 mask
    @State var maskStyle : MaskStyle = .none
    
    @State var segmentedIndex = 0
    
    @State var data : [Int] = []
    
    
    @Binding var showMenuBtn : Bool
    
    //MARK: -
    
    var body: some View{
        
        VStack{
            if imagesList.isEmpty {
                    ProgressView("Loading…")
                }else{
                    Pager(page: page, data: data , id: \.self ){ index in
                        let url = imagesList[index].url!
                          NukePage(urlString: url )
                            
                    }
                    .interactive(rotation:  isAnima ? isRotation : false )
                    .interactive(opacity:  isAnima ? ( isOpacity ? 0.8 : 1.0) : 1.0 )
                    .interactive(scale:  isAnima ? ( isScale ? 0.8 : 1.0 ) : 1.0)
                    .onPageChanged{ i in
                        self.currentIndex = i
                        self.currentPage = i
                    }
                    .itemSpacing(20)
                    .if( isTopToBottom , else:  isRightToLeft ) { view in
                        view.vertical(.topToBottom)
                    } done: {  view in
                        view.horizontal(.rightToLeft)
                    }
                    .frame(height: UIScreen.main.bounds.height)
                    .mask( ImageDarkMask(style: $maskStyle , size: CGSize( width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ) ) )
                    .edgesIgnoringSafeArea(.bottom)
                    .background(Color.black)
//                    .gesture(
//                        MagnificationGesture()
//                            .onChanged{ _ in
//                                if !draggingList[currentIndex] {
//                                    draggingList[currentIndex] = true
//                                }
//                            }
//                            .updating($scale, body: { (value, scale, trans) in
//                                if value.magnitude < 0.9 {
//                                    scale = 1.0
//                                }else{
//                                    scale = value.magnitude
//                                }
//                                let _scale = scale
//                                DispatchQueue.main.async {
//                                    self.imagesScaleList[self.currentIndex] = _scale
//                                }
//                            })
//                            .onEnded{_ in
//                                if draggingList[currentIndex] {
//                                    draggingList[currentIndex] = false
//                                }
//                            }
//                    )
//                    .if( isTopToBottom ){ view in
//                        view.background(Color.white)
//                    }
                }
        }
                
        .onAppear{
            if showMenuBtn {
                showMenuBtn = false
            }
            _ = PageSizeModel(name: name){ count in
                print("get page size \(count)")
                var tmpUrlList = [MangaPageObject ]()
                for i in 0 ..< count {
                    let url = "\(serverUrl)/getPage?name=\(name.urlEncoded())&index=\(i)"
                    tmpUrlList.append( MangaPageObject(url: url) )
                }
                imagesList.append(contentsOf: tmpUrlList)
                draggingList.append(contentsOf:  Array(repeating: false, count: count ) )
                totalPageCount = count
                data = Array(0..<count)
                imagesScaleList = Array(repeating: 1.0, count: count)
            }
        }
        .navigationBarTitle(Text("\(name)"), displayMode: .inline)
        .navigationBarHidden(self.navBarHidden)
        .animation( .easeInOut(duration: 0.16) )
        .onTapGesture {
            self.navBarHidden.toggle()
        }
        .navigationBarItems(
            trailing:
                HStack(alignment: .center, spacing: 5){
                     let count = self.lastReadModel.find(name)
                    if count > 0 {
                        CapsuleLable(text: "Option")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                self.isSheetShown = true
                            }
                        Spacer(minLength: 0)
                        Button(action: {
                            self.jumpPageCount = count
                            page = .withIndex(jumpPageCount)
                            self.currentIndex = count
                            
                        }){
                            CircleLableView(text: "\(count + 1)")
                        }.frame(width: 28 , height: 28)
                    }else{
                        
                        CapsuleLable(text: "Option")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                self.isSheetShown = true
                            }
                        
                    }
                }
        )
        
        .addPartialSheet(style: self.sheetStyle)
        .onDisappear{
            self.lastReadModel.save(name: name , count: currentPage)
        }
        .onChange(of: self.segmentedIndex ) { value in
            print("on Change \(value)")
            DispatchQueue.main.async {
                switch value {
                           case 0:
                               maskStyle = .none
                           case 1:
                               maskStyle = .little
                           case 2:
                               maskStyle = .medium
                           case 3:
                               maskStyle = .deep
                           default:
                               break
                           }
            }
            
           
            
        }
        
        
        .partialSheet(isPresented: $isSheetShown) {
            _ControllView(total: totalPageCount, jumpPageCount: $jumpPageCount ,  current: Double(currentIndex) , page: $page  , currentIndex : $currentIndex , segmentedIndex: $segmentedIndex )

        }
        
        .edgesIgnoringSafeArea(.all)
        .onChange(of: currentIndex , perform: {jumpPageCount in
            print(jumpPageCount)
        })
    }
}


