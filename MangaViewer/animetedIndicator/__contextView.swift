//
//  __contextView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/27.
//

import SwiftUI

struct __contextView: View {
    var body: some View {
        __Home()
    }
}


struct __Home : View{
    
    var colors : [Color] = [.red , .blue , .pink , .purple ]
    @State var offset : CGFloat = 0
 
    var body: some View{
        
        ScrollView(.init()){
            TabView{
                ForEach(colors.indices , id: \.self ){ index in
                    if index == 0 {
                        colors[index]
                            .overlay(
                                GeometryReader{ proxy -> Color in
                                let minX = proxy.frame(in: .global ).minX
                                DispatchQueue.main.async {
                                    print(minX)
                                    withAnimation(.default){
                                        self.offset = -minX
                                    }
                                }
                                return Color.clear
                                
                                }
                                .frame(width: 0, height: 0)
                                ,alignment : .leading
                            )
                    }
                    else{
                        colors[index]
                    }
                    
                }
            }
            
           
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(
                HStack(spacing : 15 ){
                ForEach(colors.indices , id : \.self){ index in
                    Capsule()
                        .fill(Color.white)
                        .frame(width : getIndex() == index ? 20 : 7 , height: 7)
                }
                
            }
                    .overlay(
                        Capsule()
                            .fill(Color.white)
                            .frame(width : 20 , height:  7)
                            .offset(x : getOffset())
                        
                        , alignment : .leading
                    )
                    .padding(.bottom , UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .padding(.bottom , 10)
                , alignment: .bottom
            )
        }
        .ignoresSafeArea()
        .coordinateSpace(name : "mySpace")
     
    }
    func getIndex()->Int{
        let index = Int(round(Double(offset / getWidth())))
        return index
    }
    
    
    func getOffset()-> CGFloat{
        let progress = offset / getWidth()
        return 22 * progress
        
    }
    
}

extension View {
    func getWidth()->CGFloat{
        return UIScreen.main.bounds.width
    }
}

struct contextView2_Previews: PreviewProvider {
    static var previews: some View {
        __Home()
    }
}
