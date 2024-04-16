//
//  MainTabView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/24.
//

import Foundation
import SwiftUI

struct MainTabView : View {
   
      
    
        @State var tabSelection: Tabs = .tab1
           var body: some View {
               NavigationView{
                   TabView(selection: $tabSelection){
                       
//                       NewBooksView(  )
                       Text("...")
                        .tabItem {
                                   Image(systemName: "books.vertical")
                                   Text("书架")
                                 }
                       .tag(Tabs.tab1)
                       
                       
                           NavigationLink(destination: Text("2")){
                               VStack{
                                   Text("Here is Tab 2")
                                   Text("Tap me to NavigatedView")
                               }
                           }
                           .tabItem {
                                   Image(systemName: "star")
                                   Text("收藏")
                                 }
                       .tag(Tabs.tab2)
                   }
                   .navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))//add the NavigationBarTitle here.
               }
           }
           
           enum Tabs{
               case tab1, tab2
           }
           
           func returnNaviBarTitle(tabSelection: Tabs) -> String{//this function will return the correct NavigationBarTitle when different tab is selected.
               switch tabSelection{
                   case .tab1: return "书架"
                   case .tab2: return "收藏"
               }
           }
        
    
    
    
}
