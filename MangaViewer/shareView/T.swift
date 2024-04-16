//
//  T.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/7/23.
//

import SwiftUI

struct T: View {
    
    @State var selectedTab : String = "Home"
    
    var body: some View {
        
        TabView(selection: $selectedTab ){
            
            TSettings()
                .tag("Home")
            
            
            TSettings()
                .tag("Home1")
            
        }
        
        
        
    }  
}

struct T_Previews: PreviewProvider {
    static var previews: some View {
        T()
    }
}

struct TSettings : View {
    var body: some View{
        NavigationView{
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
