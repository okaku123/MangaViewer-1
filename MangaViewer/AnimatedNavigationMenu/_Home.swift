//
//  _Home.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/6/25.
//

import SwiftUI

struct _Home: View {
    
    @Binding var selectedTab : String
    
    @Binding var showMenuBtn : Bool
    
    @Binding var showMenu : Bool
    
    init(selectedtab : Binding<String> , showMenuBtn : Binding<Bool> , showMenu : Binding<Bool>) {
        self._selectedTab = selectedtab
        self._showMenuBtn = showMenuBtn
        self._showMenu = showMenu
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
       
        TabView(selection: $selectedTab ){
            WebManager(showMenuBtn: $showMenuBtn)
                .tag("WebManager")
                .disabled( !(selectedTab == "WebManager") )
            KeystoreBookManager( showMenuBtn : $showMenuBtn )
                .tag("KeystoreBookManager")
                .disabled( !(selectedTab == "KeystoreBookManager") )
            RemoteControllerView( selectedTab: $selectedTab  )
                .tag("控制器")
                .disabled( !(selectedTab == "控制器") )
            ShareContextView( showMenuBtn: $showMenuBtn) 
                .tag("串流")
                .disabled( !(selectedTab == "串流") )
            _SettingsView()
                .tag("设置")
                .disabled( !(selectedTab == "设置") )
//            Help()
//                .tag("Help")
            
            Notifications()
                .tag("Notifications")
        }
        .disabled(showMenu ? true : false )
    }
}

struct _Home_Previews: PreviewProvider {
    static var previews: some View {
        _ContentView()
    }
}

struct HomePage : View {
    
    var body: some View{
        NavigationView{
            VStack(alignment: .leading, spacing: 20){
                Image("pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width - 50, height: 400)
                    .cornerRadius(20)
                
                VStack( alignment: .leading, spacing: 5, content: {
                        Text("Jenna Ezarik")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    
                        Text("iJustine`s Sister,YoutTuber ,Techine...")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                })
            }
            .navigationTitle("Home")
        }.navigationViewStyle(.stack)
    }
}


struct History : View {
    var body: some View{
        NavigationView{
            Text("History")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("History")
        }
    }
}

struct Notifications : View {
    var body: some View{
        NavigationView{
            Text("Notifications")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Notifications")
        }
    }
}

struct Settings : View {
    var body: some View{
        NavigationView{
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Settings")
        }
    }
}



