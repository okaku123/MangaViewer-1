//
//  PageNavView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/27.
//

import SwiftUI
import Nuke

struct PageNavView: View {
    
    @State var count = 20
    @Binding var currentIndex : Int
    @State var offset : CGFloat = 0
    
    
    let halfWidth = UIScreen.main.bounds.width / 2  - 20
    let dx = UIScreen.main.bounds.width / 2
    
    var body: some View {
        VStack{
            Spacer()
            ScrollViewReader{ proxy in
            ScrollView(.horizontal , showsIndicators: false ){
               
                    HStack(spacing : 15){
                        
                        Spacer()
                            .frame(width: halfWidth - 15 )
                            .id("-1")
                        
                        ForEach(0..<count , id : \.self){ index in
                            
                            if index == 0 {
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width : getIndex() == index ? 40 : 14 , height: 14)
                                    .overlay(
                                        GeometryReader{ proxy -> Color in
                                        let minX = proxy.frame(in: .global ).minX
                                        DispatchQueue.main.async {
                                            if minX >= 0 {

                                                offset = halfWidth - minX

                                            }else{
                                                offset = -minX + halfWidth
                                            }
                                        }
//                                        move()
//                                        print(offset)
                                        return Color.clear
                                        
                                    }
                                    .frame(width: 0, height: 0)
                                        ,alignment : .leading
                                    )
                                    .id("\(index)")
                                
                            }else{
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width : getIndex() == index ? 40 : 14 , height: 14)
                                    .animation(.default)
                                    .id("\(index)")
                            }
                        }
                        
                        Spacer()
                            .frame(width: halfWidth - 15 )
                            .id("-2")
                        
                    }
                    .frame(height: 40)
                    .offset(x  :   -CGFloat ( currentIndex * 55 )   )
                
                }
            }
            .background(Color.gray)
//            .padding(.horizontal , 20)
            .padding(.bottom , UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .padding(.bottom , 10)
           
            
        }
        .overlay(
            VStack{
            Spacer()
            Capsule()
                .fill(Color.white)
                .frame(width : 40 , height:  14)
                .padding(.bottom , UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .padding(.bottom , 23)
                .offset(x : halfWidth  )
               
        }
            
            , alignment : .leading
        )
        
    }
        
    func getIndex()->Int{
        let index = Int( offset / 29.0  )
                    
//            UISelectionFeedbackGenerator().selectionChanged()
        return index
    }
    
    func move(){
        let index = Int( offset / 29.0  )
        if index != currentIndex  , index >= 0 , index < count{
            DispatchQueue.main.async {
                currentIndex = index
                UISelectionFeedbackGenerator().selectionChanged()
            }
        }
    }
    
    
    func getOffset()-> CGFloat{
        let progress = offset / getWidth()
        return 22 * progress
        
    }
    
}

//struct PageNavView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageNavView()
//    }
//}
