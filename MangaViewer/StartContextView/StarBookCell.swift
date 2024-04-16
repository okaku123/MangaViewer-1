//
//  StarBookSell.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/26.
//

import SwiftUI
import NukeUI
import Nuke

struct StarBookCell: View {

    @State var book : Book!
    var beforeSize : CGSize
    var afterSize : CGSize
    @State var press : Bool = false
    @Binding var showMenuBtn : Bool
    @Binding var selection : String?
    @State var tag : String
    
    
    var body: some View {
    
        NavigationLink( destination: {
            VStack{
                if book.group.isEmpty{
                    _NewDetailsView( name : book.name  , showMenuBtn : $showMenuBtn)
                }else{
                    GroupView( name : book.name , bookNameList : book.group , showMenuBtn : $showMenuBtn)
                }
            }
        }()
            , tag : tag , selection : $selection ){
            
            ZStack{
                LazyImage(source: URL(string : book.getCoverUrl() )! )
                    .aspectRatio(contentMode: .fill)
                    .transition(.fade)
                    .frame(width: press ? beforeSize.width : afterSize.width ,
                           height: press ? beforeSize.height : afterSize.height )
                    .cornerRadius(4)
                    .clipped()
                if !book.group.isEmpty{
                    CircleLableView(text : "\(book.group.count + 1)" )
                        .frame(width : 20 , height : 20  , alignment: .topLeading)
                        .padding(EdgeInsets(top: 115, leading: 80, bottom: 0, trailing: 0))
                }
            }
            .id(tag)
            .onTapGesture {
                withAnimation(.spring()){
                    press = true
                }
                Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                    withAnimation(.spring()){
                        press = false
                    }
                    Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                        selection = tag
                    }
                }
            }
        }
        .id(tag)
        
    }
}

