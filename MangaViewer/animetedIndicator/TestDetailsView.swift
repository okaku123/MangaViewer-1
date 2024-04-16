//
//  TestDetailsView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/27.
//


import Combine
import Foundation
import SwiftUI
import SDWebImageSwiftUI
import UIKit
import SwiftUIPager
import Alamofire


struct TestDetailsView: View {
  
    
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
    
    @State var imagesList : [ Color ] = [.red , .gray, .yellow , .purple , .blue]
    
    
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
    
    @State var data  = 0..<5
    
    
    @Binding var showMenuBtn : Bool
    
    var body: some View{
        
        ZStack{
        
        VStack{
            if imagesList.isEmpty {
                    ProgressView("Loading…")
                }else{
                    Pager(page: page, data: data , id: \.self ){ index in
                            imagesList[index]
                    }
                    .onPageChanged{ i in
                        self.currentIndex = i
                        self.currentPage = i
                    }
                    .itemSpacing(20)
                }
        }
        .animation( .easeInOut(duration: 0.16) )
        .edgesIgnoringSafeArea(.all)
        PageNavView(currentIndex: $currentPage )
            
            
        }
        
            
    }
}

