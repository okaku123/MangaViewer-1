//
//  SideMenu.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/6/25.
//

import SwiftUI

struct SideMenu: View {
    
    @Binding var selectedTab : String
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            
            Image(systemName: "star")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                .padding(.top , 50)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text("jenna Ezarik")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Button(action: {}, label: {
                    Text("View Profile")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(0.7)
                })
            })
            
            VStack(alignment: .leading, spacing: 10 ){
                TabButton(image : "house" , title :"WebManager" , selectedTab : $selectedTab , animation : animation )
                TabButton(image : "clock.arrow.circlepath" , title :"KeystoreBookManager" , selectedTab : $selectedTab , animation : animation )
                TabButton(image : "dial.min.fill" , title :"控制器" , selectedTab : $selectedTab , animation : animation )
                TabButton(image : "dot.radiowaves.left.and.right" , title :"串流" , selectedTab : $selectedTab , animation : animation )
                
                TabButton(image : "gear" , title :"设置" , selectedTab : $selectedTab , animation : animation )
                
//                TabButton(image : "questionmark.circle" , title :"Help" , selectedTab : $selectedTab , animation : animation )
            }.padding(.leading , -15)
            .padding(.top , 50)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6, content: {
                TabButton(image : "rectangle.righthalf.inset.fill.arrow.right" , title :"Log out" , selectedTab : $selectedTab , animation : animation ) 
                    .padding(.leading , -15 )
                
                Text("App Version 1.2.34")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.6)
            })
        })
        .padding()
//        .frame(minWidth: .infinity, maxWidth: .infinity ,  alignment: .topLeading )
        .frame(width: UIScreen.main.bounds.width ,  alignment: .topLeading )
        
     
    }
}

