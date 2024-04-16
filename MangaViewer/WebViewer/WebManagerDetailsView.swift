//
//  KeystoreBookmanagerDetailsView.swift
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
import FileKit
import ZIPFoundation

struct WebManagerDetailsView : View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    @EnvironmentObject var hudManager : HUDManager
    @State var direction : swipeDirection = .none
    
    @State var showingAlert : Bool = false
    @State var showingJumpAlert : Bool = false
    
    
    // MARK: 阅读设置 -
    @AppStorage("isAnima") var isAnima: Bool = true
    @AppStorage("isScale") var isScale: Bool = true
    @AppStorage("isOpacity") var isOpacity: Bool = true
    @AppStorage("isRotation") var isRotation: Bool = true
    @AppStorage("isLoop") var isLoop: Bool = false
    @AppStorage("isRightToLeft") var isRightToLeft: Bool = false
    @AppStorage("isTopToBottom") var isTopToBottom: Bool = false
    
    @EnvironmentObject var showMeunContext: ShowMeunContext
    
    let sheetStyle = PartialSheetStyle(background: .blur(.systemMaterialDark),
                                       handlerBarColor: Color(UIColor.systemGray2),
                                       enableCover: true,
                                       coverColor: Color.black.opacity(0.001) ,
                                       blurEffectStyle:  .systemChromeMaterial,
                                       cornerRadius: 10,
                                       minTopDistance: 110)
    
    @State var isSheetShown = false
    var name : String = ""
    var bookName: String
    @Binding var zipEntryList: [HttpZipEntry]
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
    
    @State var segmentedIndex = 0
    @State var data : [Int] = []
    @State var showDownloadProgress = false
    @State var showMangaView = false
    
    @State var fileDownloadProgress = 0.0
    @State var sortedEntrys: [Entry] = []
    @State var archive: Archive? = nil
    @State var jumpCount : Int = 0
        
    
    func whenDirectionChange(_ direction: swipeDirection ){
        
        if showingAlert {
            if direction == .left {
                jumpCount -= 10
                
            }else if direction ==  .right{
                jumpCount += 10
            }
            return
        }

        if direction == .left {
            jumpPageCount += 1
            if jumpPageCount > data.count - 1 {
                jumpPageCount = data.count - 1
            }
            page = .withIndex(jumpPageCount)
            self.lastReadModel.save(name: bookName , count: jumpPageCount)
        }
        
        if direction == .right{
            jumpPageCount -= 1
            if jumpPageCount < 0 {
                jumpPageCount = 0
            }
            page = .withIndex(jumpPageCount)
            self.lastReadModel.save(name: bookName , count: jumpPageCount)
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
                var p = currentIndex + jumpCount
                if p > data.count - 1 {
                    p = data.count - 1
                }
                if p < 0 {
                    p = 0
                }
                self.page = Page.withIndex(p)
                jumpPageCount = p
                jumpCount = 0
            }
        }
        
        if direction == .circle {
            let count = self.lastReadModel.find(name)
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
                let count = self.lastReadModel.find(bookName)
                print(count)
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
    
    func onAppear(){
        let count = self.lastReadModel.find(bookName)
        print(bookName)
        print(count)
        
        if isIpad {
            withAnimation{
                navBarHidden = true
            }
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
//                guard let data =  "pageCount:\(book.pageCount)".data(using: .utf8) ,
//                      let peer = jobConnectionManager.connectedPeers.first else {
//                    return
//                }
//                jobConnectionManager.send(data, to: peer)
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
            
            if jobConnectionManager.connected {
                if let data =  "pageCount:\(zipEntryList.count)".data(using: .utf8) ,
                   let peer = jobConnectionManager.connectedPeers.first  {
                    jobConnectionManager.send(data, to: peer)
                }
            }
        }
    }
    
    
    var body: some View{
        
        
        VStack(alignment:.center){
            if data.count == 0 {
                Spacer()
                ProgressView(value: fileDownloadProgress)
                    .progressViewStyle(GaugeProgressStyle(color: .blue, lineWidth: 8))
                    .frame(width: 40, height: 40)
                Spacer()
            }else {
                Pager(page: page, data: data , id: \.self ){ index in
                    WebPage( bookName: self.bookName ,zipEntry: zipEntryList[index] )
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
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.black)
            }
        }
        .onAppear{
            if data.count == 0 {
                for count in 0 ..< zipEntryList.count {
                    data.append(count)
                }
            }
            showMeunContext.hideMeun()
            onAppear()
        }
        .onChange(of: direction ){ direction in
            whenDirectionChange( direction )
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
        
        .navigationBarTitle(Text("\(name)"), displayMode: .inline)
        .navigationBarHidden(self.navBarHidden)
        .animation( .easeInOut(duration: 0.16) )
        .onTapGesture {
            self.navBarHidden.toggle()
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: Button("返回"){
                self.presentationMode.wrappedValue.dismiss()
            }
        )
        .onChange(of: currentPage){  currentPage in
            print("save: \(currentPage)")
            self.lastReadModel.save(name: bookName , count: currentPage)
        }
        .onDisappear{
            showMeunContext.showMeun()
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: currentIndex , perform: {jumpPageCount in
            print(jumpPageCount)
        })
    }
}



