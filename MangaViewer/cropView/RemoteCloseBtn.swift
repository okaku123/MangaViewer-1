//
//  RemoteCloseBtn.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/12.
//

/// 适合远程遥控具备框选高亮的推出按钮

import SwiftUI

struct RemoteCloseBtn: View {
    
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    @Binding var focus : Bool
    var callback : (()->())?
    @State var isAnime = false
    
    var body: some View {
        CloseBtn()
            .opacity( isAnime ?  0.0 : 1.0 )
            .background(
                ZStack{
                if selectedTab == title {
                    Circle()
                        .stroke(Color.accentColor , lineWidth: 2 )
                        .padding(.all , -5)
                        .opacity(selectedTab == title ? 1 : 0)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                }
            })
            .onChange(of: focus){ focus in
                if focus {
                    withAnimation{
                        isAnime = true
                    }
                    Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false){_ in
                        withAnimation{
                            isAnime = false
                        }
                        self.focus = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                            self.callback?()
                        }
                    }
                }
                
            }
    }
}

struct RemoteCloseBtn_Previews: PreviewProvider {
    
    @State static var title = "0"
    @State static var selectedTab = "0"
    @Namespace static var animation
    @State static var focus = true

    
    static var previews: some View {
        RemoteCloseBtn(title: "0",
                       selectedTab : $selectedTab ,
                       animation : animation ,
                       focus: $focus)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
