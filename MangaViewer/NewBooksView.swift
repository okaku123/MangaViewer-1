//
//  NewBooksView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/24.
//

import Foundation
import SwiftUI
import Foundation
import Alamofire
import Nuke
import NukeUI


struct NewBooksView : View{
    
    @Binding var showMenuBtn : Bool
    
    //数据源
    @State var bookMap = [[Book]]()
    @State var loadingPages = [Int]()
    
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

    var starBookModel = StarBookModel()
    
    func headerView(type: String) -> some View{
        return HStack {
            Spacer()
            Text("Section \(type)")
                .foregroundColor(.white)
            Spacer()
        }.padding(.all, 4).background(Color.blue)
    }

    func  setPage(_ count : Int){
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
            
//            DispatchQueue.main.async {
//                if loadingPages.contains(count) ,
//                   let index = self.loadingPages.firstIndex(of: count){
//                    loadingPages.remove(at: index)
//                }
//            }
            
            
            switch response.result {
            case let .success(data):
                DispatchQueue.main.async {
                    print("load end \(data.count )")
                    print("okokokok")
                    self.bookMap[ count - 1 ] = []
                    self.bookMap[ count - 1 ] = data
                }
                break
            default :
                break
            }
        }
    }
    
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                if self.bookMap.isEmpty {
                    ProgressView("加载中....")
                }else{
                    GeometryReader{ geo in
                        let count : CGFloat = isIpad ? 5 : 3
                        let space = count + 1
                        
                        let beforeWidth : CGFloat =  ( geo.size.width - 20 * space ) / count
                        let afterWidth  : CGFloat = beforeWidth * 0.9
                        let beforeHeight : CGFloat =  ( geo.size.width - 20 * space ) / count * 1.3
                        let afterHeight : CGFloat = beforeHeight * 0.9
                        
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
                                                        
                                                        let width = !cellPressList[i][j] ? beforeWidth : afterWidth
                                                        let height = !cellPressList[i][j] ? beforeHeight : afterHeight
                                                        
                                                        NavigationLink( destination:
                                                                            {
                                                        VStack{
                                                                
                                                                if book.group.isEmpty{
                                                                    _NewDetailsView(name : book.name  , showMenuBtn : $showMenuBtn)
                                                                }else{
                                                                    
                                                                    GroupView( name : book.name , bookNameList : book.group , showMenuBtn : $showMenuBtn)
                                                                }
                                                            }
                                                        }()
                                                                        , tag : "\(i)-\(j)" , selection : $selection ){
                                                            
                                                            ZStack{
                                                                NewShareBookCell(geo: geo, scroll: proxy, tag: "\(i)-\(j)", selection: $selection, book: book, selectedID: $selectedID )
                                                                if !book.group.isEmpty{
                                                                    CircleLableView(text : "\(book.group.count + 1)" )
                                                                        .frame(width : 20 , height : 20  , alignment: .topLeading)
                                                                        .padding(EdgeInsets(top: 115, leading: 80, bottom: 0, trailing: 0))
                                                                    
                                                                }
                                                            }
                                                            .id("\(i)=\(j)")
                                                            .onTapGesture {
                                                                withAnimation(.spring()){
                                                                    cellPressList[i][j] = true
                                                                }
                                                                Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                                                    withAnimation(.spring()){
                                                                        cellPressList[i][j] = false
                                                                    }
                                                                    Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                                                        self.selection = "\(i)-\(j)"
                                                                    }
                                                                }
                                                            }
                                                            .contextMenu {
                                                                Text("\(book.name)")
                                                                Divider()
                                                                
                                                                Button(action: {
                                                                    UIPasteboard.general.string = book.name
                                                                    
                                                                }) {
                                                                    HStack {
                                                                        Text("复制文件名")
                                                                        Image(systemName: "doc.on.doc")
                                                                    }
                                                                }
                                                                
                                                                Button(action: {
                                                                    // mark the selected restaurant as favorite
                                                                    starBookModel.save(book)
                                                                    
                                                                }) {
                                                                    HStack {
                                                                        Text("添加至收藏")
                                                                        Image(systemName: "star")
                                                                    }
                                                                }
                                                            }
                                                            
                                                        }
                                                        .id("\(i)-\(j)")
                                                        
                                                    }
                                                }
                                                .id("\(i)")
                                                .onAppear{
                                                    self.getPage( i + 1 )
                                                }
                                            }
                                        }
                                        
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
                        }
                        
                        
                        
                    }
                }
            } .navigationTitle("书架")
        }
        .if(isIpad){ v in
            v.navigationViewStyle(StackNavigationViewStyle())
        }
        .onDisappear{
        }
        .onAppear{
            _ = MaxPageCount{ count in
                cellPressList.removeAll()
                print(count)
                
                for _ in 0 ..< count {
                    cellPressList.append( Array(repeating:  false , count: 30) )
                }
                self.jumpSideBarCount = count
                
                self.setPage(count)
                
                getPage(1)
                
            }
        }
        
        
    }
    
    
    
    
}
