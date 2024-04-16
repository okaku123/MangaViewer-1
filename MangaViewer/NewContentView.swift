//
//  ContentView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI
import UIKit
import Nuke
import NukeUI

//var cardWidth = ( UIScreen.main.bounds.width - 85 ) / 3

var isIpad : Bool{
        return UIDevice.current.model == "iPad"
}

var cardWidth : CGFloat {
    return isIpad ?  ( UIScreen.main.bounds.width - 125 ) / 5 : ( UIScreen.main.bounds.width - 85 ) / 3
    
//    return ( UIScreen.main.bounds.width - 85 ) / 3
}


struct NewContentView: View {
    
    
   
    init() {
       
        // this is not the same as manipulating the proxy directly
              let appearance = UINavigationBarAppearance()
              
              // this overrides everything you have set up earlier.
//              appearance.configureWithTransparentBackground()
              
              // this only applies to big titles
//              appearance.largeTitleTextAttributes = [
//                .font : UIFont.systemFont(ofSize: 40 , weight: .ultraLight),
//                  NSAttributedString.Key.foregroundColor : UIColor.white
//              ]
//              // this only applies to small titles
//              appearance.titleTextAttributes = [
//                .font : UIFont.systemFont(ofSize: 20),
//                  NSAttributedString.Key.foregroundColor : UIColor.white
//              ]
              
              //In the following two lines you make sure that you apply the style for good
//              UINavigationBar.appearance().scrollEdgeAppearance = appearance
              UINavigationBar.appearance().standardAppearance = appearance
              
              // This property is not present on the UINavigationBarAppearance
              // object for some reason and you have to leave it til the end
//              UINavigationBar.appearance().tintColor = .white
        
        
          //Use this if NavigationBarTitle is with displayMode = .inline
          //UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
      }
    
    
    //    @ObservedObject var randomImages = pictureViewModel()
    //    @ObservedObject var randomImages2 = collectionPictureViewModel()
    
    @ObservedObject var bookSelfModel = BookSelfModel()
    
    @State var scrollPostion : Int = -1
    
    
    
    var colums : [GridItem]{
//        if isIpad{
//          return  [GridItem( .fixed( cardWidth ), spacing: 20),
//            GridItem( .fixed( cardWidth ), spacing: 20),
//             GridItem( .fixed( cardWidth ), spacing: 20),
//             GridItem( .fixed( cardWidth ), spacing: 20),
//            GridItem( .fixed( cardWidth ), spacing: 25)]
//        }else{
          return  [GridItem( .fixed( cardWidth ), spacing: 20),
            GridItem( .fixed( cardWidth ), spacing: 20),
            GridItem( .fixed( cardWidth ), spacing: 25)]
//        }
    }
    
    @State var cellPressList : [[Bool]] = {
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
    //        @State private var showingSheet = false
    @State private var showingActionSheet = false
    @State private var jumpSideBarCount = 0
    
    @State private var isSettingsShow = false
//    @State var jumpLastRead : Bool = false
    
    
    // 自定义 previewContextMenu 的 选项
    let deleteAction = UIAction(
        title: "Remove rating",
        image: UIImage(systemName: "delete.left"),
        identifier: nil,
        attributes: UIMenuElement.Attributes.destructive, handler: {_ in print("Foo")})
    
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
            Text("此处代码编译器无法处理已经被屏蔽")
        }
    }
    
//    var body: some View {
//        NavigationView{
//
//            VStack{
//
//                if self.bookSelfModel.bookMap.isEmpty {
//                    Text("loading")
//                }else{
//                    GeometryReader{ geo in
//
////                        let count : CGFloat = isIpad ? 5 : 3
////                        let space = count + 1
//
////                        let count : CGFloat = 3
////                        let space = count + 1
//
////                        let beforeWidth : CGFloat =  ( geo.size.width - 85 ) / 3
////                        let afterWidth  : CGFloat = beforeWidth * 0.9
////                        let beforeHeight : CGFloat =  ( geo.size.width - 85 ) / 3 * 1.3
////                        let afterHeight : CGFloat = beforeHeight * 0.9
//
//                        let beforeWidth : CGFloat =  cardWidth
//
//                        let afterWidth  : CGFloat = beforeWidth * 0.9
//
//                        let beforeHeight : CGFloat =  cardWidth * 1.3
//
//                        let afterHeight : CGFloat = beforeHeight * 0.9
//
//                        ScrollViewReader { proxy in
//                            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)){
//                                VStack{
//                                    ScrollView{
//                                            LazyVGrid(columns: colums , spacing: 20 , pinnedViews: [.sectionHeaders]){
//                                                ForEach( 0 ..< self.bookSelfModel.bookMap.count , id: \.self ){ i in
//                                                    let bookArray = self.bookSelfModel.bookMap[i]
//                                                    Section(header: headerView(type: "\( i + 1)" )) {
//                                                        ForEach(  0 ..< bookArray.count , id: \.self ){ j in
//                                                            let book = bookArray[j]
//
//                                                            let width = !cellPressList[i][j] ? beforeWidth : afterWidth
//                                                            let height = !cellPressList[i][j] ? beforeHeight : afterHeight
//
//                                                            NavigationLink( destination:
//
//                                                                                Spacer()
////                                                                        {
////                                                                    VStack{
////
////                                                                        if book.group.isEmpty{
////                                                                            _NewDetailsView(name : book.name)
////                                                                        }else{
////
////                                                                            GroupView( name : book.name , bookNameList : book.group)
////                                                                        }
////                                                                    }
////                                                                    }()
//                                                                            , tag : "\(i)-\(j)" , selection : $selection ){
//
//                                                                ZStack{
//
//                                                                    LazyImage(source: URL(string : book.getCoverUrl() )! )
//                                                                        .contentMode(.aspectFill)
//                                                                        .transition(.fadeIn(duration: 0.33))
//                                                                        .frame(width: width , height: height )
//                                                                        .cornerRadius(4)
//                                                                        .clipped()
////                                                                        .animation(.easeIn(duration: 0.12))
//
//                                                                    if !book.group.isEmpty{
//                                                                        CircleLableView(text : "\(book.group.count + 1)" )
//                                                                            .frame(width : 20 , height : 20  , alignment: .topLeading)
//                                                                            .padding(EdgeInsets(top: 115, leading: 80, bottom: 0, trailing: 0))
//
//                                                                    }
//                                                                }
//                                                                .id("\(i)=\(j)")
//                                                                .onTapGesture {
//                                                                    withAnimation(.spring()){
//                                                                        cellPressList[i][j] = true
//                                                                    }
//                                                                    Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
//                                                                        withAnimation(.spring()){
//                                                                            cellPressList[i][j] = false
//                                                                        }
//                                                                        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
//                                                                            self.selection = "\(i)-\(j)"
//                                                                        }
//                                                                    }
//                                                                }
////                                                                .contextMenu {
////
////
////                                                                    Text("\(book.name)")
////                                                                    Divider()
////
////                                                                    Button(action: {
////                                                                        UIPasteboard.general.string = book.name
////
////                                                                    }) {
////                                                                        HStack {
////                                                                            Text("复制文件名")
////                                                                            Image(systemName: "doc.on.doc")
////                                                                        }
////                                                                    }
////
////                                                                    Button(action: {
////                                                                        // mark the selected restaurant as favorite
////
////
////                                                                    }) {
////                                                                        HStack {
////                                                                            Text("添加至收藏")
////                                                                            Image(systemName: "star")
////                                                                        }
////                                                                    }
////                                                                }
//
//                                                            }
//                                                            .id("\(i)-\(j)")
//
//
//
//
//                                                        }
//                                                    }
//                                                    .id("\(i)")
//                                                    .onAppear{
//                                                        print("section \(i) has appear ...")
//                                                        bookSelfModel.getPage( i + 1 )
//                                                    }
//                                                }
//                                            }
//
//                                    }
//                                }
//                                .frame(width: geo.size.width  , height: geo.size.height )
//
//                                VStack{
//                                    JumpSetcionSideBar(count : jumpSideBarCount , proxy : proxy  )
//                                }
//                                .frame(width: 20, height: 300, alignment: .center)
//
//                            }
//                        }
//
//
//
//                    }
//                }
//            }
//            .onAppear{
//                _ = MaxPageCount{ count in
//                    if count > 20 {
//                        for _ in 20 ..< count {
//                            cellPressList.append( Array(repeating:  false , count: 30) )
//                        }
//                    }
//                    self.jumpSideBarCount = count
//                    bookSelfModel.setPage(count)
//                    bookSelfModel.getPage(1)
//                }
//            }
//            .navigationTitle("MangaViewer")
//            .navigationBarItems(
//                trailing : Menu(content: {
//                    Button(action: {
//                        isSettingsShow.toggle()
//                    }) {
//                        Label("设置", systemImage: "folder.badge.plus")
//                    }
//                    Button(action: {
//
//                    }) {
//                        Label("Select", systemImage: "checkmark.circle")
//                    }
//                    Button(action: {
//                        self.showingActionSheet = true
//                    }) {
//                        Label("ActionSheet", systemImage: "pencil.circle")
//                    }
//                }, label: { Image(systemName: "ellipsis.circle") } )
//            )
//
//
//        }
//        .sheet(isPresented: $isSettingsShow ) {
//             _SettingsView()
//         }
////        .addPartialSheet(style: .defaultStyle())
////        .navigationBarColor(backgroundColor: .systemTeal, tintColor: .white)
//        .actionSheet(isPresented: $showingActionSheet) {
//            ActionSheet(title: Text("Change background"), message: Text("Select a new color"), buttons: [
//                .default(Text("Open Facebook")) { UIApplication.shared.open(URL(string: "https://facebook.com")!) },
//                .default(Text("Open Instagram")) { UIApplication.shared.open(URL(string: "https://instagram.com")!) },
//                .default(Text("Open Twitter")) { UIApplication.shared.open(URL(string: "https://twitter.com")!) },
//                .cancel()
//            ])
//        }
//    }
}


struct NewContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewContentView()
    }
}
