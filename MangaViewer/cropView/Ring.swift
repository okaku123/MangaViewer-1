//
//  Ring.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/14.
//

import SwiftUI

struct Ring: View {
    var width : CGFloat
    @Binding var isOn : Bool
    @State var dotJump = false
    
    
    var randomList = (0...60).random(25)
    
    
    func getSize(index : Int) -> CGFloat {
        if index < 10 || index > 50 {
            return 3
        }
        if index >= 10 && index < 20 {
            return 4
        }
        if index >= 40 && index <= 50{
            return 4
        }else{
            return 5
        }
    }
    
    func getOffset(index: Int)->CGFloat{
        if randomList.contains( index) {
            return 10
        }else {
            return 0
        }
        
    }
    
    
    var body: some View {
        GeometryReader{ geo in
        ZStack{
            ForEach(1...60, id: \.self ){ index in
                Circle()
                    .fill( isOn ? Color.green : Color.white)
                    .frame(width: getSize(index: index), height: getSize(index: index))
//                    .offset(x: -( width / 2 ) )
                    .offset(x: -( width / 2 )  )
                    .rotationEffect(.init(degrees: Double(index) * 6 ))
//                    .scaleEffect( dotJump ? getOffset(index: index) : 1.0 )
//                    .rotationEffect(.init(degrees: Double( getOffset(index: index) )))
                    .opacity(getSize(index: index) == 3 ? 0.7 : (isOn ? 1 : 0.8 ))
//                    .animation(.spring())
                
            }
        }
        .frame(width : geo.size.width , height:  geo.size.height )
        .rotationEffect(.init(degrees: 90))
        .onAppear{
//            dotJump.toggle()
//            withAnimation(.spring().repeatForever()){
//                dotJump.toggle()
//            }
            
        }
        
     }
    }
}

struct Ring_Previews: PreviewProvider {
    
    @State static var isOn = true
    
    static var previews: some View {
        GeometryReader{ geo in
        ZStack{
            Ring(width: UIScreen.main.bounds.width / 2 , isOn: $isOn)
                .offset(y: 70)
            Ring(width: UIScreen.main.bounds.width / 1.6  , isOn: $isOn)
                .offset(y: 80)
            Ring(width: UIScreen.main.bounds.width / 1.3 , isOn: $isOn)
                .offset(y: 90)
            Ring(width: UIScreen.main.bounds.width / 1.1, isOn: $isOn)
                .offset(y: 100)
            Ring(width: UIScreen.main.bounds.width , isOn: $isOn)
                .offset(y: 100)
            
        }
        .frame(width : geo.size.width , height:  geo.size.height )
        .padding(.bottom , 60)
        .background(Color.black)
        }
        
    }
}
