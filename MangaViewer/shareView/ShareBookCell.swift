//
//  ShareBookCell.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/7/16.
//

import SwiftUI
import Alamofire
import Nuke
import NukeUI


struct ShareBookCell: View {
    
    var geoProxy : GeometryProxy
    var scrollProxy : ScrollViewProxy
    var navigationTag : String
    @Binding var selection : String?
    var book : Book
    @Binding var isHighLight : Bool
    
    init(geo : GeometryProxy , scroll : ScrollViewProxy , tag : String , selection : Binding<String?> , book : Book  , isHighLight : Binding<Bool> ) {
        self.geoProxy = geo
        self.scrollProxy = scroll
        self.navigationTag = tag
        self._selection = selection
        self.book = book
        self._isHighLight = isHighLight
    }
    
    var body: some View {
    
        
        
       return ZStack{
           
           
           let count : CGFloat = isIpad ? 5 : 3
           let space = count + 1
           
           let beforeWidth : CGFloat =  ( geoProxy.size.width - 20 * space ) / count
           let afterWidth  : CGFloat = beforeWidth * 0.9
           let beforeHeight : CGFloat =  ( geoProxy.size.width - 20 * space ) / count * 1.3
           let afterHeight : CGFloat = beforeHeight * 0.9
           
           
//            let beforeWidth : CGFloat =  ( geoProxy.size.width - 20 * 4 ) / 3
//            let afterWidth  : CGFloat = beforeWidth * 0.9
//            let beforeHeight : CGFloat =  ( geoProxy.size.width - 20 * 4 ) / 3 * 1.3
//            let afterHeight : CGFloat = beforeHeight * 0.9
            
            let width = !isHighLight ? beforeWidth : afterWidth
            let height = !isHighLight ? beforeHeight : afterHeight
            
        LazyImage(source: URL(string : book.getCoverUrl() )! )
               .aspectRatio(contentMode: .fill)
               .transition(.fade)
                .frame(width: width , height: height )
                .cornerRadius(4)
                .clipped()
                .onTapGesture {
                    print("...")
                    withAnimation(.spring()){
                        isHighLight = true
                    }
                    Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                        withAnimation(.spring()){
                            isHighLight = false
                        }
                        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                            selection = navigationTag
                        }
                    }
                }

            if !book.group.isEmpty{
                CircleLableView(text : "\(book.group.count + 1)" )
                    .frame(width : 20 , height : 20  , alignment: .topLeading)
                    .padding(EdgeInsets(top: 115, leading: 80, bottom: 0, trailing: 0))
            }
        }
        .id( navigationTag )
 
    }
}



struct ShareBookCellPreview : View {
    @State  var selection : String? = "0-0"
    @State  var isHighLight = false
    var body: some View{
        VStack{
            let url = "https://images.unsplash.com/photo-1527822984742-e14743fc7f60?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyMzM2NDB8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MjYxODI5Nzc&ixlib=rb-1.2.1&q=80&w=400"
            let book = Book(name: "...", cover: url, group: [])
        ScrollViewReader{ p0 in
            GeometryReader{ p1 in
                ShareBookCell(geo: p1, scroll: p0, tag: "0-0", selection: $selection , book: book  , isHighLight:  $isHighLight )
            }
        }
        }.frame(width: UIScreen.main.bounds.width   , height:  UIScreen.main.bounds.width / 2)
    }
    
}


struct ShareBookCell_Previews: PreviewProvider {
    
    @State static var selection : String? = "0-0"
    @State static var isHighLight = false
    static var previews: some View {
   
        VStack{
            let url = "https://images.unsplash.com/photo-1527822984742-e14743fc7f60?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyMzM2NDB8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MjYxODI5Nzc&ixlib=rb-1.2.1&q=80&w=400"
            let book = Book(name: "...", cover: url, group: [])
        ScrollViewReader{ p0 in
            GeometryReader{ p1 in
                ShareBookCell(geo: p1, scroll: p0, tag: "0-0", selection: $selection , book: book , isHighLight: $isHighLight   )
            }
        }
        }.frame(width: UIScreen.main.bounds.width   , height:  UIScreen.main.bounds.width / 2)
        
       
    }
}
