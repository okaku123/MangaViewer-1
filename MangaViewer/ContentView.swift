//
//  ContentView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI

struct ContentView: View {
    
    @ObservedObject var randomImages = pictureViewModel()
    @ObservedObject var randomImages2 = collectionPictureViewModel()
    
    var colums = [
        GridItem(spacing: 0 ),
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
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
    
    // 自定义 previewContextMenu 的 选项
    let deleteAction = UIAction(
        title: "Remove rating",
        image: UIImage(systemName: "delete.left"),
        identifier: nil,
        attributes: UIMenuElement.Attributes.destructive, handler: {_ in print("Foo")})
    
    func headerView(type: String) -> some View{
        return HStack {
            Spacer()
            Text("Section header \(type)")
            Spacer()
        }.padding(.all, 10).background(Color.blue)
    }
    
    
    var body: some View {
        NavigationView{
            VStack{
                if randomImages.photoMap.isEmpty {
                    Text("loading")
                }else{
                    
                    GeometryReader{ geo in
                        
                        let beforeWidth : CGFloat =  ( geo.size.width - 20 * 4 ) / 3
                        let afterWidth  : CGFloat = beforeWidth * 0.9
                        let beforeHeight : CGFloat =  ( geo.size.width - 20 * 4 ) / 3 * 1.3
                        let afterHeight : CGFloat = beforeHeight * 0.9
                        
                        ScrollView{
                            LazyVGrid(columns: colums , spacing: 20, pinnedViews: [.sectionHeaders]){
                                ForEach( 0 ..< randomImages.photoMap.count , id: \.self ){ i in
                                    let photoArray = randomImages.photoMap[i]
                                    Section(header: headerView(type: "\( i + 1)")) {
                                        ForEach(  0 ..< photoArray.count , id: \.self ){ j in
                                            let photo = photoArray[j]
                                            let width = !cellPressList[i][j] ? beforeWidth : afterWidth
                                            let height = !cellPressList[i][j] ? beforeHeight : afterHeight
                                            
                                            NavigationLink( destination: DetailsView(picture: photo , imagesList: randomImages2.photoArray ) , tag : "\(i)-\(j)" , selection : $selection ){
                                                
                                                VStack{
                                                    WebImage(url: URL(string: photo.urls.thumb))
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: width , height: height )
                                                        .cornerRadius(14)
                                                        .clipped()
                                                        .animation(.easeIn(duration: 0.12))
                                                }
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
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pictures")
            .navigationBarItems(
                trailing : Menu(content: {
                    Button(action: {
                        
                    }) {
                        Label("New folder", systemImage: "folder.badge.plus")
                    }
                    Button(action: {
                        
                    }) {
                        Label("Select", systemImage: "checkmark.circle")
                    }
                    Button(action: {
                        self.showingActionSheet = true
                    }) {
                        Label("ActionSheet", systemImage: "pencil.circle")
                    }
                }, label: { Image(systemName: "ellipsis.circle") } )
            )
        }
        .navigationBarColor(backgroundColor: .systemTeal, tintColor: .white)
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Change background"), message: Text("Select a new color"), buttons: [
                .default(Text("Open Facebook")) { UIApplication.shared.open(URL(string: "https://facebook.com")!) },
                .default(Text("Open Instagram")) { UIApplication.shared.open(URL(string: "https://instagram.com")!) },
                .default(Text("Open Twitter")) { UIApplication.shared.open(URL(string: "https://twitter.com")!) },
                .cancel()
            ])
        }
        
     
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
