//
//  ShareBookCell.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/7/16.
//

import SwiftUI
import Alamofire
import NukeUI
import Nuke

struct NewShareBookCell: View {
    
    var geoProxy : GeometryProxy
    var scrollProxy : ScrollViewProxy
    var navigationTag : String
    @Binding var selection : String?
    var book : Book
    @Binding var selectedID : String
    
    init(geo : GeometryProxy ,
         scroll : ScrollViewProxy ,
         tag : String ,
         selection : Binding<String?> ,
         book : Book  ,
         selectedID : Binding<String> ) {
        
        self.geoProxy = geo
        self.scrollProxy = scroll
        self.navigationTag = tag
        self._selection = selection
        self.book = book
        self._selectedID = selectedID
    }
    
    var body: some View {
    
       return ZStack{
           
           let count : CGFloat = isIpad ? 5 : 3
           let space = count + 1
           let beforeWidth : CGFloat =  ( geoProxy.size.width - 20 * space ) / count
           let beforeHeight : CGFloat =  ( geoProxy.size.width - 20 * space ) / count * 1.3
           let isHighLight = ( navigationTag == selectedID ) ? true : false
          
        LazyImage(source: URL(string : book.getCoverUrl() )! )
               .aspectRatio(contentMode: .fill)
               .transition(.fade(duration: 0.33))
                .frame(width: beforeWidth , height: beforeHeight )
                .cornerRadius(4)
                .clipped()
                .scaleEffect( isHighLight ? 0.9 : 1 )
                .animation(.spring())
                .onTapGesture {
                    selectedID = navigationTag
                    Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                        DispatchQueue.main.async {
                         
                        selectedID = "none"
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


