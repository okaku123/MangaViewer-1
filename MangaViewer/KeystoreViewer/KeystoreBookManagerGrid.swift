//
//  KeystoreBookManagerGrid.swift
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


struct KeystoreBookManagerGrid : View{
    
    var scroll: ScrollViewProxy
    @Binding var showMenuBtn : Bool
    @Binding var loadingPages: [Int]
    var bookMap: [[KeyStoreBook]]
    var geometryProxy: GeometryProxy
    var booksModel: GetBooksModel
    //新高亮系统
    var selectedID: String
    //确定打开的item
    @Binding var selection: String?

    
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
    
    
    @State private var showingActionSheet = false
    @State private var jumpSideBarCount = 0
    
    func headerView(type: String) -> some View{
        return HStack {
            Spacer()
            Text("Section \(type)")
                .foregroundColor(.white)
            Spacer()
        }.padding(.all, 4).background(Color.blue)
    }
    
    var body: some View{
            VStack{
                ScrollView{
                    LazyVGrid(columns: colums , spacing: 20 , pinnedViews: [.sectionHeaders]){
                        ForEach( 0 ..< bookMap.count , id: \.self ){ i in
                            Section(header: headerView(type: "\( i + 1)" )) {
                                ForEach(  0 ..< bookMap[i].count , id: \.self ){ j in
                                    KeystoreManagerBookCell(
                                        book: bookMap[i][j],
                                        geoProxy : geometryProxy,
                                        tag : "\(i)-\(j)",
                                        selection: $selection,
                                        selectedID : selectedID
                                    )
                                    .id("Cell-\(i)-\(j)")
                                }
                            }
                            .id("Section-\(i)")
                            .onAppear{
                                booksModel.getPage( i + 1 )
                            }
                        }
                    }
                    
                }
            }
            .frame(width: geometryProxy.size.width  , height: geometryProxy.size.height )
    }
}
