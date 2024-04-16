//
//  AnimateMenuBtn.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/8/14.
//

import SwiftUI

struct AnimateMenuBtn: View {
    
    
    @Binding var showMenu : Bool
    
    var body: some View {
                        Button(action: {
                            withAnimation(.spring(), {
                                showMenu.toggle()
                            })
                        }, label: {
                            VStack( spacing: 5 ){
                                Capsule()
                                    .fill(showMenu ? Color.white : Color.primary)
                                    .frame(width: 30 , height: 3)
                                    .rotationEffect(.init(degrees: showMenu ? -50 : 0))
                                    .offset(x: showMenu ? 2: 0, y: showMenu ? 9 : 0)
        
                                VStack(spacing : 5){
                                    Capsule()
                                        .fill(showMenu ? Color.white : Color.primary)
                                        .frame(width: 30 , height : 3)
        
                                    Capsule()
                                        .fill(showMenu ? Color.white : Color.primary)
                                        .frame(width: 30 , height: 3)
                                        .offset( y: showMenu ? -8 : 0)
        
                                }
                                .rotationEffect(.init(degrees: showMenu ? 50 : 0))
                            }
                            .contentShape(Rectangle())
        
                        })
                        .padding()
                    
    }
}

struct AnimateMenuBtn_Previews: PreviewProvider {
    @State static var showMenu = false
    static var previews: some View {
        AnimateMenuBtn(showMenu: $showMenu)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("AnimateMenuBtn")
    }
}
