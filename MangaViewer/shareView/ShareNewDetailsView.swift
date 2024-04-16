//
//  ShareNewDetailsView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/7/19.
//

import Combine
import Foundation
import SwiftUI
import SDWebImageSwiftUI
import UIKit
import SwiftUIPager
import Alamofire

struct ShareNewDetailsView : View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    @EnvironmentObject var hudManager : HUDManager
    
    @Binding var showMenuBtn : Bool
    @State var direction : swipeDirection = .none
    
    @AppStorage("isAnima") var isAnima: Bool = true
    @AppStorage("isScale") var isScale: Bool = true
    @AppStorage("isOpacity") var isOpacity: Bool = true
    @AppStorage("isRotation") var isRotation: Bool = true
    @AppStorage("isLoop") var isLoop: Bool = false
    @AppStorage("isRightToLeft") var isRightToLeft: Bool = false
    @AppStorage("isTopToBottom") var isTopToBottom: Bool = false
    
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
    
    @State var showingAlert : Bool = false
    @State var showingJumpAlert : Bool = false
    //    @State var isSkip : Bool = false
    
    @State var jumpCount : Int = 0
    
    
    var body: some View{
        
        VStack{
            if imagesList.isEmpty {
                ProgressView("Loading…")
            }else{
                //                    Spacer()
                //                        .frame(width: UIScreen.main.bounds.width, height: 3 * ( 45 +  UIApplication.shared.windows.first!.safeAreaInsets.top )   )
                Pager(page: page, data: data , id: \.self ){ index in
                    NukePage(urlString: imagesList[index].url! )
                }
                .interactive(rotation:  isAnima ? isRotation : false )
                .interactive(opacity:  isAnima ? ( isOpacity ? 0.8 : 1.0) : 1.0 )
                .interactive(scale:  isAnima ? ( isScale ? 0.8 : 1.0 ) : 1.0)
                .onPageChanged{ i in
                    self.currentIndex = i
                    self.currentPage = i
                }
                .itemSpacing(20)
                //                    .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! - 45.0)
                .if( isTopToBottom , else:  isRightToLeft ) { view in
                    view.vertical(.topToBottom)
                } done: {  view in
                    view.horizontal(.rightToLeft)
                }
                .mask( ImageDarkMask(style: $maskStyle , size: CGSize( width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ) ) )
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.black)
                .gesture(
                    MagnificationGesture()
                        .onChanged{ _ in
                            if !draggingList[currentIndex] {
                                draggingList[currentIndex] = true
                            }
                        }
                        .updating($scale, body: { (value, scale, trans) in
                            if value.magnitude < 0.9 {
                                scale = 1.0
                            }else{
                                scale = value.magnitude
                            }
                            let _scale = scale
                            DispatchQueue.main.async {
                                self.imagesScaleList[self.currentIndex] = _scale
                            }
                        })
                        .onEnded{_ in
                            if draggingList[currentIndex] {
                                draggingList[currentIndex] = false
                            }
                        }
                )
            }
        }
        //        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 45.0)
        .onChange(of: direction ){ direction in
            
            if showingAlert {
                if direction == .left {
                    // set jump page count
                    jumpCount -= 10
                    
                }else if direction ==  .right{
                    jumpCount += 10
                }
                return
            }
            
            
            if direction == .left {
                jumpPageCount += 1
                if jumpPageCount > imagesList.count - 1 {
                    jumpPageCount = imagesList.count - 1
                }
                page = .withIndex(jumpPageCount)
            }
            
            if direction == .right{
                jumpPageCount -= 1
                if jumpPageCount < 0 {
                    jumpPageCount = 0
                }
                page = .withIndex(jumpPageCount)
            }
            
            if direction == .tap2 {
                
                withAnimation{
                    navBarHidden = false
                }
                
                Timer.scheduledTimer(withTimeInterval: 0.4 , repeats: false){_ in
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                
            }
            
            if direction == .tap3 {
                showingAlert.toggle()
                Timer.scheduledTimer(withTimeInterval: 5, repeats: false){ t in
                    showingAlert = false
                    
                    // count down over do jump 😊
                    var p = currentIndex + jumpCount
                    if p > imagesList.count - 1 {
                        p = imagesList.count - 1
                    }
                    if p < 0 {
                        p = 0
                    }
                    self.page = Page.withIndex(p)
                    jumpPageCount = p
                    //after jump page finish ,set jump count zero 😊
                    jumpCount = 0
                    
                }
                
            }
            
            if direction == .circle {
                
                let count = self.lastReadModel.find(name)
                print(count)
                guard count > 0 else {
                    return
                }
                showingJumpAlert = true
                Timer.scheduledTimer(withTimeInterval: 5, repeats: false){ _ in
                    showingJumpAlert = false
                }
            }
            
            if direction == .up {
                if showingJumpAlert {
                    let count = self.lastReadModel.find(name)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false){ _ in
                        DispatchQueue.main.async {
                            self.jumpPageCount = count
                            page = .withIndex(jumpPageCount)
                            self.currentIndex = count
                        }
                    }
                    showingJumpAlert = false
                }
            }
            
            if direction == .down {
                if showingJumpAlert {
                    showingJumpAlert = false
                }
            }
            
            
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("跳转页面"),
                  message: Text("左右滑动快进快退 \n \(  jumpCount > 0 ? "前进\(jumpCount)页" : "后退\(-jumpCount)页" ) "),
                  dismissButton: .default(Text("好")))
        }
        .alert(isPresented: $showingJumpAlert ) {
            Alert(title: Text("跳转上次阅读"),
                  message: Text("上滑动确认，下滑动取消。不操作3秒后取消"),
                  primaryButton: .default(Text("跳转")),
                  secondaryButton: .default(Text("取消")))
        }
        
        //        .overlay( swipeGesture{ direction in
        //
        //            if direction == .left {
        //                jumpPageCount += 1
        //                if jumpPageCount > imagesList.count - 1 {
        //                    jumpPageCount = imagesList.count - 1
        //                }
        //                page = .withIndex(jumpPageCount)
        //
        //                if let id = jobConnectionManager.employees.first {
        //                    jobConnectionManager.send( "left" , to:  id  )
        //                }
        //
        //            }
        //
        //            if direction == .right {
        //                jumpPageCount -= 1
        //                if jumpPageCount < 0 {
        //                    jumpPageCount = 0
        //                }
        //                page = .withIndex(jumpPageCount)
        //
        //                if let id = jobConnectionManager.employees.first {
        //                    jobConnectionManager.send( "right" , to:  id  )
        //                }
        //
        //            }
        //
        //            if direction == .tap1 {
        //                self.presentationMode.wrappedValue.dismiss()
        //
        //                if let id = jobConnectionManager.employees.first {
        //                    jobConnectionManager.send( "tap1" , to:  id  )
        //                }
        //
        //            }
        //
        //
        //        })
        
        .onAppear{
            
            if isIpad {
                withAnimation{
                    navBarHidden = true
                }
            }
            
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
                
                //将总页面数量发送给遥控器
                if jobConnectionManager.connected {
                    if let data =  "pageCount:\(imagesList.count)".data(using: .utf8) ,
                          let peer = jobConnectionManager.connectedPeers.first  {
                        jobConnectionManager.send(data, to: peer)
                    }
                }
            }
            //
            
            
            do{
                //            let count = UnsplashUrlArray.count
                //            imagesList = UnsplashUrlArray.map{ url in
                //                return MangaPageObject(url: url)
                //            }
                //            draggingList.append(contentsOf: Array(repeating: false, count: count ) )
                //            totalPageCount = count
                //            data = Array(0..<count)
                //            imagesScaleList = Array(repeating: 1.0, count: count)
            }
            
            
            jobConnectionManager.jobReceivedHandler = { msg in
                if msg == "left" {
                    self.direction = .none
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .left
                    }
                }else if msg == "right" {
                    self.direction = .none
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .right
                    }
                }else if msg == "tap1"{
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .tap1
                    }
                }else if msg == "tap2"{
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .tap2
                    }
                }else if msg == "tap3"{
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .tap3
                    }
                }else if msg == "circle" {
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .circle
                    }
                }
                else if msg == "up" {
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .up
                    }
                }
                else if msg == "down" {
                    Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                        self.direction = .down
                    }
                }else if msg == "pageCount" {
                    guard let data =  "pageCount:\(imagesList.count)".data(using: .utf8) ,
                          let peer = jobConnectionManager.connectedPeers.first else {
                        return
                    }
                    jobConnectionManager.send(data, to: peer)
                }else if msg.contains( "jump:" ){
                    guard let count =  Int(  msg.replacingOccurrences(of: "jump:", with: "") ) else {
                        return
                    }
                    self.jumpPageCount = count
                    page = .withIndex(jumpPageCount)
                    self.currentIndex = count
                    
                    hudManager.title = "已经跳转\(count)页"
                    hudManager.show.toggle()
                    
                }
            }
        }
        
        
        .navigationBarTitle(Text("\(name)"), displayMode: .inline)
        .navigationBarHidden( self.navBarHidden )
        //        .navigationBarHidden( true )
        .animation( .easeInOut(duration: 0.16) )
        //        .onTapGesture {
        //            self.navBarHidden.toggle()
        //        }
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
        .onDisappear{
            self.lastReadModel.save(name: name , count: page.index )
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
        .edgesIgnoringSafeArea(.all)
    }
}



