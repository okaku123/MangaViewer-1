//
//  SimpleContextView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/8/10.
//

import Foundation
import SwiftUI
import Foundation
import Alamofire
import Nuke

struct SimpleContextView: View {
    
    //数据源
    @State var bookMap = [[Book]]()
    @State var loadingPages = [Int]()
    @State var jumpCount : Int = 0
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
    
    @State private var selection: String? = nil
    //新高亮系统
    @State var selectedID = "0-0"
    var starBookModel = StarBookModel()
    @State private var jumpSideBarCount = 0
    @State var showMenuBtn = false
    
    
    func headerView(type: String) -> some View{
        return HStack {
            Spacer()
            Text("Section \(type)")
                .foregroundColor(.white)
            Spacer()
        }.padding(.all, 4).background(Color.blue)
    }
    
    func getData(){
        let Books = UnsplashUrlArray.map{ url in
            return Book(name: UUID().uuidString, cover: url , group: [])
        }
        bookMap = Array(repeating: Books, count: 10)
    }
    
    func setPage(_ count : Int){
        let empty = Book()
        for _ in 0 ..< count {
            self.bookMap.append( Array( repeating: empty , count: 30 ))
        }
    }
    
    func getPage( _ count : Int = 1) {
        if loadingPages.contains(count){ return }
//        if bookMap.count < count , let f = bookMap[count].first , !f.name.isEmpty { return }
        
        if bookMap.count < count  { return }
        
        loadingPages.append(count)
        let url = "\(serverUrl)/getBookByApp?page=\(count)&pageSize=30"
        AF.request(url).responseDecodable(of: [Book].self ){ response in
            
            debugPrint(response)
            
            DispatchQueue.main.async {
                if loadingPages.contains(count) ,
                   let index = self.loadingPages.firstIndex(of: count){
                    loadingPages.remove(at: index)
                }
            }
            
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
                break
                
            }
        }
    }
    
    
   @State var currentIndex = IndexPath(row: 0, section: 0)
    
    
    var body: some View {
        
        NavigationView{
        VStack{
        KRefreshScrollView( progressTint: .blue , arrowTint: .blue ){
            
                    GeometryReader{ geo in
                        if bookMap.isEmpty{
                            VStack{
                            ProgressView("加载中")
                            }.frame(width: geo.size.width , height: geo.size.height)
                        }else{
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
                                                                        ShareNewDetailsView(showMenuBtn :  $showMenuBtn, name : book.name)
                                                                           
                                                                        
                                                                    }else{
                                                                        ShareGroupView( name : book.name , bookNameList : book.group , showMenuBtn : $showMenuBtn)
                                                                        
                                                                    }
                                                                }
                                                            }()
                                                                            , tag : "\(i)-\(j)" , selection : $selection ){
                                                                
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
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
                    
        
        } onUpdate : {
            
            self.bookMap.removeAll()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){
                _ = MaxPageCount{ count in
                    self.jumpSideBarCount = count
                    self.setPage(count)
                    self.getPage(1)
                }
            }
        }
            
        }
        .background(Color.black.opacity(0.06).ignoresSafeArea())
        .onAppear{
            _ = MaxPageCount{ count in
                self.jumpSideBarCount = count
                self.setPage(count)
                getPage(1)
            }
        }
        .navigationBarTitle("书架", displayMode: .inline)
       
        
        }
    }
}

struct SimpleContextView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleContextView()
    }
}
