//
//  KeystoreBookManager.swift
//  MangaViewer
//
//  Created by okaku yang on 2024/2/12.
//

import Foundation
import SwiftUI
import Foundation
import Alamofire
import Nuke
import NukeUI


struct KeystoreBookManager : View{
    
    @EnvironmentObject var showMeunContext : ShowMeunContext
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    
    @Binding var showMenuBtn : Bool
    
    //数据源model
    @ObservedObject var getBooksModel = GetBooksModel()
    
    @State var loadingPages = [Int]()
    
    //显示alert快速跳转
    @State var showingAlert : Bool = false
    @State var jumpCount : Int = 0
    //
    //跳动位置
    @State var scrollPostion : Int = -1
    //网格布局
    private var colums : [GridItem] {
        if !isIpad {
            return [GridItem( .fixed( cardWidth ), spacing: 20),
                    GridItem( .fixed( cardWidth ), spacing: 20),
                    GridItem( .fixed( cardWidth ), spacing: 25)]
        }else{
            return [GridItem( .fixed( cardWidth ), spacing: 20),
                    GridItem( .fixed( cardWidth ), spacing: 20),
                    GridItem( .fixed( cardWidth ), spacing: 20),
                    GridItem( .fixed( cardWidth ), spacing: 20),
                    GridItem( .fixed( cardWidth ), spacing: 25)]
        }
    }
    
    //新高亮系统
    @State var selectedID = "0-0"
    @State  var cellPressList : [[Bool]] = {
        var list = [[Bool]]()
        for _ in 0 ..< 20 {
            var _list = [Bool]()
            for _ in 0 ..< 30 {
                _list.append(false)
            }
            list.append(_list)
        }
        return list
    }()
    
    @State private var selection: String? = nil
    @State private var showingActionSheet = false
    @State private var jumpSideBarCount = 0
    //跳转用
    @State var currentIndex = IndexPath(row: 0, section: 0)
    @State var direction : swipeDirection = .none
    //远程控制sheet
    @State var isSheetShown = false
    
    
    func headerView(type: String) -> some View{
        return HStack {
            Spacer()
            Text("Section \(type)")
                .foregroundColor(.white)
            Spacer()
        }.padding(.all, 4).background(Color.blue)
    }
    
    func handleControllerReceivedHandler(msg: String, proxy: ScrollViewProxy){
        if showingAlert {
            if msg == "up" {
                jumpCount -= 1
                
            }else if msg == "down" {
                jumpCount += 1
            }
            return
        }
        
        if msg == "right" {
            currentIndex.row += 1
            if currentIndex.row > getBooksModel.bookMap[currentIndex.section].count - 1 {
                currentIndex.section += 1
                currentIndex.row = 0
                if currentIndex.section > getBooksModel.bookMap.count - 1 {
                    currentIndex.section = getBooksModel.bookMap.count - 1
                }
            }
            
            selectedID = "\(currentIndex.section)-\(currentIndex.row)"
            DispatchQueue.main.async {
                withAnimation{
                    proxy.scrollTo("Cell-\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                }
            }
            
        }else if msg == "left" {
            currentIndex.row -= 1
            if currentIndex.row < 0 {
                currentIndex.row = 0
                currentIndex.section -= 1
                if currentIndex.section < 0 {
                    currentIndex.section = 0
                }
            }
            selectedID = "\(currentIndex.section)-\(currentIndex.row)"
            DispatchQueue.main.async {
                withAnimation{
                    proxy.scrollTo("Cell-\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                }
                
            }
        }else if msg == "down" {
            currentIndex.row += colums.count
            if currentIndex.row > getBooksModel.bookMap[currentIndex.section].count - 1 {
                currentIndex.section += 1
                if currentIndex.section > getBooksModel.bookMap.count - 1 {
                    currentIndex.section = getBooksModel.bookMap.count - 1
                    currentIndex.row = getBooksModel.bookMap.last!.count - 1
                }else{
                    currentIndex.row = 0
                }
            }
            selectedID = "\(currentIndex.section)-\(currentIndex.row)"
            DispatchQueue.main.async {
                withAnimation{
                    proxy.scrollTo("Cell-\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                }
                
            }
        }else if msg == "up" {
            currentIndex.row -= colums.count
            if currentIndex.row < 0 {
                currentIndex.section -= 1
                if currentIndex.section < 0 {
                    currentIndex.section = 0
                    currentIndex.row = 0
                }else{
                    currentIndex.row = getBooksModel.bookMap[currentIndex.section].count + currentIndex.row
                }
            }
            selectedID = "\(currentIndex.section)-\(currentIndex.row)"
            DispatchQueue.main.async {
                withAnimation{
                    proxy.scrollTo("Cell-\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                }
            }
        }else if msg == "tap2"{
            self.direction = .none
            Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                self.direction = .tap2
            }
        }else if msg == "tap3"{
            self.direction = .none
            Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                self.direction = .tap3
            }
        }
    }
    
    func whenDirectionChange(scrollProxy: ScrollViewProxy ){
        //快速跳转
        if showingAlert {
            if direction == .up {
                jumpCount -= 1
            }else if direction ==  .down{
                jumpCount += 1
            }
            return
        }
        
        if direction == .right {
            currentIndex.row += 1
            if currentIndex.row > getBooksModel.bookMap[currentIndex.section].count - 1 {
                currentIndex.section += 1
                currentIndex.row = 0
                if currentIndex.section > getBooksModel.bookMap.count - 1 {
                    currentIndex.section = getBooksModel.bookMap.count - 1
                }
            }
     
        }
        if direction == .left {
            currentIndex.row -= 1
            if currentIndex.row < 0 {
                currentIndex.row = 0
                currentIndex.section -= 1
                if currentIndex.section < 0 {
                    currentIndex.section = 0
                }
            }
        }
        if direction == .down {
            currentIndex.row += colums.count
            if currentIndex.row > getBooksModel.bookMap[currentIndex.section].count - 1 {
                currentIndex.section += 1
                if currentIndex.section > getBooksModel.bookMap.count - 1 {
                    currentIndex.section = getBooksModel.bookMap.count - 1
                    currentIndex.row = getBooksModel.bookMap.last!.count - 1
                }else{
                    currentIndex.row = 0
                }
            }
        }
        if direction == .up{
            currentIndex.row -= colums.count
            if currentIndex.row < 0 {
                currentIndex.section -= 1
                if currentIndex.section < 0 {
                    currentIndex.section = 0
                    currentIndex.row = 0
                }else{
                    currentIndex.row = getBooksModel.bookMap[currentIndex.section].count + currentIndex.row
                }
            }
        }
        DispatchQueue.main.async {
            selectedID = "\(currentIndex.section)-\(currentIndex.row)"
            withAnimation{
                scrollProxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
            }
        }
        
        if direction == .tap2 {
            selection = "\(currentIndex.section)-\(currentIndex.row)"
        }
        
        //MARK: tap3 -快速跳转setion
        if direction == .tap3 {
            showingAlert.toggle()
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false){ t in
                showingAlert = false
                // count down over do jump 😊
                var p = currentIndex.section + jumpCount
                if p > getBooksModel.bookMap.count - 1 {
                    p = getBooksModel.bookMap.count - 1
                }
                if p < 0 {
                    p = 0
                }
                currentIndex.section = p
                currentIndex.row = 0

                selectedID = "\(currentIndex.section)-\(currentIndex.row)"
                DispatchQueue.main.async {
                    withAnimation{
                        scrollProxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                    }
                }
                //after jump page finish ,set jump count zero 😊
                jumpCount = 0
            }
        }
    }
        
    var body: some View{
        NavigationView{
            VStack{
                if getBooksModel.bookMap.isEmpty {
                    ProgressView("加载中....")
                        .onAppear{
                            getBooksModel.getPage(0)
                            getBooksModel.getPage(1)
                        }
                }else{
                    GeometryReader{ geo in
                        let count : CGFloat = isIpad ? 5 : 3
                        ScrollViewReader { scrollProxy in
                            KeystoreBookManagerGrid(
                                scroll: scrollProxy,
                                showMenuBtn: $showMenuBtn,
                                loadingPages: $loadingPages,
                                bookMap: getBooksModel.bookMap,
                                geometryProxy: geo,
                                booksModel: getBooksModel,
                                selectedID: selectedID,
                                selection: $selection
                            )
                            .onAppear{
                                jobConnectionManager.jobReceivedHandler = { msg in
                                    handleControllerReceivedHandler( msg:msg, proxy:scrollProxy )
                                }
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("跳转页面"),
                                      message: Text("上下滑动跳转setion \n \(  jumpCount > 0 ? "前进\(jumpCount)setion" : "后退\(-jumpCount)setion" ) "),
                                      dismissButton: .default(Text("好")))
                            }
                            .onChange(of: self.direction , perform: { _ in
                                whenDirectionChange( scrollProxy: scrollProxy )
                            })
                        }
                    }
                }
            }
            .onAppear{
            }
            .navigationTitle("书架")
            .navigationBarItems(
                trailing:
                    HStack(alignment: .center, spacing: 5){
                        CapsuleLable(text: "远程控制")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                self.isSheetShown = true
                            }
                    }
            )
            .addPartialSheet(style: .defaultStyle())
            .partialSheet(isPresented: $isSheetShown) {
                ShareControllView(jobConnectionManager : jobConnectionManager)
            }
        }
        .if(isIpad){ v in
            v.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
