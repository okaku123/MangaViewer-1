//
//  ScreenComet.swift
//  MangaViewer
//
//  Created by okaku on 2024/4/16.
//

import Foundation
import SwiftUI

struct ScreenComet: View {

    @State var showMenu = false
    @State var showMenuBtn = true

    var body: some View {
        ZStack{
            Color("blue")
                .ignoresSafeArea()
            
            ZStack{
                Color.white
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -50 : 0)
                    .padding(.vertical , showMenu ? 100 : 0)
                
                Color.white
                    .opacity(0.4)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -150 : 0)
                    .padding(.vertical , showMenu ? 160 : 0)
                
                
                Color.white
                    .opacity(0.2)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -250 : 0)
                    .padding(.vertical , showMenu ? 210 : 0)

            }
            .scaleEffect(showMenu ? 0.84 : 1)
            .offset(x: showMenu ? getRect().width -  (isIpad ? 700 : 120 ) : 0 )
            .ignoresSafeArea()
            .overlay(
                ZStack(alignment: .center){
                    HStack{
                            AnimateMenuBtn(showMenu: $showMenu)
                        Spacer()
                    }
                    .frame(width : UIScreen.main.bounds.width - 100)
                    .background(Color.white.opacity(0.01))
                }
                .frame(width : UIScreen.main.bounds.width - 100)
                ,
                alignment : .topLeading
                
            )
            .onTapGesture {
                if showMenu {
                    withAnimation(.spring(), {
                        showMenu.toggle()
                    })
                }
            }
        }
    }
}

struct ScreenComet_Previews: PreviewProvider {
    static var previews: some View {
        ScreenComet()
    }
}

