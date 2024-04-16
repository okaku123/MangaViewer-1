//
//  StarContextView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/26.
//

import SwiftUI

struct StarContextView: View {
    
    @State var bookList = [Book]()
    @State var pressList = [Bool]()
    @State  var selection: String? = nil
    @Binding var showMenuBtn : Bool
    var starBookModel = StarBookModel()
    
    public init( _ showMenuBtn : Binding<Bool>  ){
        self._showMenuBtn = showMenuBtn
        
    }
    
    private var colums = [
        GridItem( .fixed( cardWidth ), spacing: 20),
        GridItem( .fixed( cardWidth ), spacing: 20),
        GridItem( .fixed( cardWidth ), spacing: 25)
    ]
    
    public var body: some View {
        NavigationView{
            VStack{
                if bookList.isEmpty {
                    ProgressView("加载中....")
                        .onAppear{
                            if !showMenuBtn{
                                showMenuBtn = true
                            }
                           
                            bookList = starBookModel.bookList
                            pressList = Array(repeating: false, count: starBookModel.bookList.count)
                        }
                }else{
                    GeometryReader{ geo in
                        
                        let beforeWidth : CGFloat =  ( geo.size.width - 20 * 4 ) / 3
                        let afterWidth  : CGFloat = beforeWidth * 0.9
                        let beforeHeight : CGFloat =  ( geo.size.width - 20 * 4 ) / 3 * 1.3
                        let afterHeight : CGFloat = beforeHeight * 0.9
                        
                        let afterSize = CGSize(width: afterWidth , height: afterHeight )
                        let beforeSize = CGSize(width: beforeWidth , height: beforeHeight )
                        
                        ScrollViewReader { proxy in
                            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)){
                                VStack{
                                    ScrollView{
                                        LazyVGrid(columns: colums , spacing: 20 ){
                                            ForEach( 0 ..< bookList.count , id: \.self ){ i in
                                                let book = bookList[i]
                                                StarBookCell(book: book, beforeSize: beforeSize, afterSize: afterSize, press: pressList[i], showMenuBtn: $showMenuBtn, selection: $selection, tag: "\(i)")
                                            }
                                        }
                                        
                                    }
                                }
                                .frame(width: geo.size.width  , height: geo.size.height )
                            }
                            
                            .onAppear{
                                if !showMenuBtn{
                                    showMenuBtn = true
                                }
                                bookList = starBookModel.bookList
                                pressList = Array(repeating: false, count: starBookModel.bookList.count)
                                
                            }
                        }
                    }
                }
            } .navigationTitle("收藏")
        }
        
    }
}


