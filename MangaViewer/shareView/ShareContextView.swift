//
//  ShareContextView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/7/13.
//

import Foundation
import SwiftUI
import Foundation
import Alamofire
import Nuke

public struct ShareContextView : View{
    
    
//    @ObservedObject var jobConnectionManager: JobConnectionManager
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    
    @Binding var showMenuBtn : Bool
//    @State var showMenuBtn = false
    @State var isSheetShown = false
    
    @State var direction : swipeDirection = .none
    
    //数据源
    @State var bookMap = [[Book]]()
    @State var loadingPages = [Int]()
//    @State var hightLightMap = [[Bool]]()
//    private var currentIndex = IndexPath(row: 0, section: 0)
    
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
    @State private var isSettingsShow = false
    
    //新高亮系统
    @State var selectedID = "0-0"
    
    
    var starBookModel = StarBookModel()
    
    func headerView(type: String) -> some View{
        return HStack {
            Spacer()
            Text("Section \(type)")
                .foregroundColor(.white)
            Spacer()
        }.padding(.all, 4).background(Color.blue)
    }
    
    func getData(){
        //        _ = UnsplashTextPictrueModel{ result in
        //                    print(result)
        //        }
        
        let Books = UnsplashUrlArray.map{ url in
            return Book(name: UUID().uuidString, cover: url , group: [])
        }
        bookMap = Array(repeating: Books, count: 10)
        
//        hightLightMap = bookMap.map{ bookList in
//            return Array(repeating: false, count: bookList.count)
//        }
        
        
    }
    
    func setPage(_ count : Int){
        let empty = Book()
        for _ in 0 ..< count {
            self.bookMap.append( Array( repeating: empty , count: 30 ))
        }
    }
    
    func getPage( _ count : Int = 1) {
        if loadingPages.contains(count){ return }
        if bookMap.count < count , let f = bookMap[count].first , !f.name.isEmpty { return }
        loadingPages.append(count)
        let url = "\(serverUrl)/getBookByApp?page=\(count)&pageSize=30"
        AF.request(url).responseDecodable(of: [Book].self ){ response in
            
            debugPrint(response)
            
            switch response.result {
            case let .success(data):
                DispatchQueue.main.async {
                    print("load end \(data.count )")
                    print("okokokok")
                    self.bookMap[ count - 1 ] = []
                    self.bookMap[ count - 1 ] = data
                }
                break
            case let .failure(_):
                DispatchQueue.main.async {
                    if loadingPages.contains(count) ,
                       let index = self.loadingPages.firstIndex(of: count){
                        loadingPages.remove(at: index)
                    }
                }
            }
        }
    }
    
//    private var currentIndex = IndexPath(row: 0, section: 0)
    
    init(showMenuBtn : Binding<Bool>) {
        self._showMenuBtn = showMenuBtn
    
        
    }
    
   @State var currentIndex = IndexPath(row: 0, section: 0)
    
    
    func handleControllerReceivedHandler(msg: String, proxy: ScrollViewProxy){
        if showingAlert {
            if msg == "up" {
                // set jump page count
                jumpCount -= 1

            }else if msg == "down" {
                jumpCount += 1
            }
            return
        }
        
        if msg == "right" {
                currentIndex.row += 1
                if currentIndex.row > bookMap[currentIndex.section].count - 1 {
                    currentIndex.section += 1
                    currentIndex.row = 0
                    if currentIndex.section > bookMap.count - 1 {
                        currentIndex.section = bookMap.count - 1
                    }
                }

                selectedID = "\(currentIndex.section)-\(currentIndex.row)"
                DispatchQueue.main.async {
                    withAnimation{
                        proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
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
                    proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                }

            }
        }else if msg == "down" {
            currentIndex.row += colums.count
            if currentIndex.row > bookMap[currentIndex.section].count - 1 {
                currentIndex.section += 1
                if currentIndex.section > bookMap.count - 1 {
                    currentIndex.section = bookMap.count - 1
                    currentIndex.row = bookMap.last!.count - 1
                }else{
                    currentIndex.row = 0
                }
            }
            selectedID = "\(currentIndex.section)-\(currentIndex.row)"
            DispatchQueue.main.async {
                withAnimation{
                    proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
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
                    currentIndex.row = bookMap[currentIndex.section].count + currentIndex.row
                }
            }
            selectedID = "\(currentIndex.section)-\(currentIndex.row)"
            DispatchQueue.main.async {
                withAnimation{
                    proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
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
    
    
    

    public var body: some View{
        
        NavigationView{
            VStack{
                if self.bookMap.isEmpty {
                    ProgressView("加载中....")
                        .onAppear{
                            
//                            getData()
                            
                            _ = MaxPageCount{ count in
                                cellPressList.removeAll()
                                for _ in 0 ..< count {
                                    cellPressList.append( Array(repeating:  false , count: 30) )
                                }

//                                hightLightMap = Array(repeating: Array(repeating: false, count: 30), count: count)

                                self.jumpSideBarCount = count
                                self.setPage(count)
                                getPage(1)
                            }
                        }
                }else{
                    
                    GeometryReader{ geo in
                        ScrollViewReader { proxy in
                            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)){
                                VStack{
                                    ScrollView{
                                        LazyVGrid(columns: colums , spacing: 20 , pinnedViews: [.sectionHeaders]){
                                            ForEach( 0 ..< bookMap.count , id: \.self ){ i in
                                                let bookArray = bookMap[i]
                                                Section(header: headerView(type: "\( i + 1)" )) {
                                                    ForEach(  0 ..< bookArray.count , id: \.self ){ j in
                                                        let book = bookArray[j]
                                                        NavigationLink( destination:
                                                                {
                                                            VStack{
                                                                if book.group.isEmpty{
                                                                    ShareNewDetailsView(showMenuBtn : $showMenuBtn, name : book.name)
                                                                        .environmentObject( jobConnectionManager )
                                                                    
                                                                }else{
                                                                    ShareGroupView( name : book.name , bookNameList : book.group , showMenuBtn : $showMenuBtn)
                                                                        .environmentObject( jobConnectionManager )
                                                                }
                                                            }
                                                        }()
                                                                        , tag : "\(i)-\(j)" , selection : $selection ){
                                                            
                                                            
//                                                            ShareBookCell(geo: geo , scroll: proxy , tag: "\(i)-\(j)", selection: $selection , book: book  , isHighLight: $hightLightMap[i][j])
                                                            
                                                            NewShareBookCell(geo: geo, scroll: proxy, tag: "\(i)-\(j)", selection: $selection, book: book, selectedID: $selectedID )
                                                            
                                                        }
                                                                        .id("\(i)-\(j)")
                                                        
                                                    }
                                                }
                                                .id("\(i)")
                                                .onAppear{
                                                    print("section \(i) has appear ...")
                                                    self.getPage( i + 1 )
                                                }
                                              
                                            }
                                        }
//                                        .drawingGroup()
                                        
                                    }
                                }
                                .frame(width: geo.size.width  , height: geo.size.height )
                             
                                VStack{
                                    Spacer()
                                    JumpSetcionSideBar(count : jumpSideBarCount , proxy : proxy )
                                }
                                .frame(width: 20, height: 300, alignment: .center)
                                .onAppear{
                                    if !showMenuBtn{
                                        showMenuBtn = true
                                    }
                                }
                                
                            }
                            .onAppear{
                                    jobConnectionManager.jobReceivedHandler = { msg in
                                        handleControllerReceivedHandler( msg:msg , proxy:proxy )
                                    }
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("跳转页面"),
                                      message: Text("上下滑动跳转setion \n \(  jumpCount > 0 ? "前进\(jumpCount)setion" : "后退\(-jumpCount)setion" ) "),
                                      dismissButton: .default(Text("好")))
                                   }
                            
                            .onChange(of: self.direction , perform: { _ in
     
                                if showingAlert {
                                    if direction == .up {
                                        // set jump page count
                                        jumpCount -= 1

                                    }else if direction ==  .down{
                                        jumpCount += 1
                                    }
                                    return
                                }
                                
//                                withAnimation{
//                                    hightLightMap[currentIndex.section][currentIndex.row] = false
//                                }
                                
                                if direction == .right {
                                    currentIndex.row += 1
                                    if currentIndex.row > bookMap[currentIndex.section].count - 1 {
                                        currentIndex.section += 1
                                        currentIndex.row = 0
                                        if currentIndex.section > bookMap.count - 1 {
                                            currentIndex.section = bookMap.count - 1
                                        }
                                    }
                             
                                }
                                
                                
                                //--------------------------------------
                                
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
                                    if currentIndex.row > bookMap[currentIndex.section].count - 1 {
                                        currentIndex.section += 1
                                        if currentIndex.section > bookMap.count - 1 {
                                            currentIndex.section = bookMap.count - 1
                                            currentIndex.row = bookMap.last!.count - 1
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
                                            currentIndex.row = bookMap[currentIndex.section].count + currentIndex.row
                                        }
                                    }

                                
                                }
                                
                                
                                DispatchQueue.main.async {
                                    selectedID = "\(currentIndex.section)-\(currentIndex.row)"
                                    withAnimation{
                                        proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
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
                                        if p > bookMap.count - 1 {
                                            p = bookMap.count - 1
                                        }
                                        if p < 0 {
                                            p = 0
                                        }
                                        currentIndex.section = p
                                        currentIndex.row = 0

                                        selectedID = "\(currentIndex.section)-\(currentIndex.row)"
                                        DispatchQueue.main.async {
                                            withAnimation{
                                                proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                                            }

                                        }
                                        //after jump page finish ,set jump count zero 😊
                                        jumpCount = 0

                                    }

                                }
                                
                                
                                
                            })
                            
                            .overlay( swipeGesture{direction in
//                                withAnimation{
//                                    hightLightMap[currentIndex.section][currentIndex.row] = false
//                                }
                                if direction == .right {
                                    currentIndex.row += 1
                                    if currentIndex.row > bookMap[currentIndex.section].count - 1 {
                                        currentIndex.section += 1
                                        currentIndex.row = 0
                                        if currentIndex.section > bookMap.count - 1 {
                                            currentIndex.section = bookMap.count - 1
                                        }
                                    }

                                    selectedID = "\(currentIndex.section)-\(currentIndex.row)"

//                                    withAnimation{
//                                        hightLightMap[currentIndex.section][currentIndex.row] = true
//                                    }
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                                        }
                                    }

                                    if let id = jobConnectionManager.employees.first {
                                        jobConnectionManager.send( "right" , to:  id  )
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
                                    selectedID = "\(currentIndex.section)-\(currentIndex.row)"
//                                    withAnimation{
//                                        hightLightMap[currentIndex.section][currentIndex.row] = true
//                                    }
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                                        }

                                    }

                                    if let id = jobConnectionManager.employees.first {
                                        jobConnectionManager.send( "left" , to:  id  )
                                    }


                                }
                                if direction == .down {
                                    currentIndex.row += colums.count
                                    if currentIndex.row > bookMap[currentIndex.section].count - 1 {
                                        currentIndex.section += 1
                                        if currentIndex.section > bookMap.count - 1 {
                                            currentIndex.section = bookMap.count - 1
                                            currentIndex.row = bookMap.last!.count - 1
                                        }else{
                                            currentIndex.row = 0
                                        }
                                    }
                                    selectedID = "\(currentIndex.section)-\(currentIndex.row)"
//                                    withAnimation{
//                                        hightLightMap[currentIndex.section][currentIndex.row] = true
//                                    }
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                                        }

                                    }

                                    if let id = jobConnectionManager.employees.first {
                                        jobConnectionManager.send( "down" , to:  id  )
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
                                            currentIndex.row = bookMap[currentIndex.section].count + currentIndex.row
                                        }
                                    }
                                    selectedID = "\(currentIndex.section)-\(currentIndex.row)"
//                                    withAnimation{
//                                        hightLightMap[currentIndex.section][currentIndex.row] = true
//                                    }
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            proxy.scrollTo("\(currentIndex.section)-\(currentIndex.row)", anchor: .center)
                                        }

                                    }


                                    if let id = jobConnectionManager.employees.first {
                                        jobConnectionManager.send( "up" , to:  id  )
                                    }

                                }

                                if direction == .tap2 {
                                    selection = "\(currentIndex.section)-\(currentIndex.row)"

                                    if let id = jobConnectionManager.employees.first {
                                        jobConnectionManager.send( "tap2" , to:  id  )
                                    }

                                }
                            } )
                            
                     
                        }
                        
                    }
                    
                }
            }
            .navigationTitle("书架")
            .navigationBarItems(
                    trailing:
                        Button(action: {
                isSheetShown.toggle()
                        }) {
                            Label("设置", systemImage: "dot.radiowaves.left.and.right")
                                .foregroundColor(Color.blue)
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

