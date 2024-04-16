//
//  OpenRemoteBtn.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/14.
//

import SwiftUI

struct OpenRemoteBtn: View {
    
    @State var isClick = false
    @Binding var isHandle : Bool
    @State var handle : (()->())? = nil
    
    var body: some View {
        VStack{
        Image(systemName: "dot.radiowaves.left.and.right")
            .foregroundColor(  isClick ? .blue : .black )
        }
            .background(
                Circle()
                    .fill(isHandle ? Color.green : Color.white )
                    .opacity( isClick ? 0.7 : 1.0 )
                    .frame(width: 40 , height: 40)
                    .scaleEffect( isClick ?  1.2 : 1.0 )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 0)
                    
            )
            .onTapGesture {
                withAnimation(.spring()){
                    isClick.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.125){
                    withAnimation(.spring()){
                        self.isClick.toggle()
                    }
                    self.isHandle.toggle()
                    self.handle?()
                }
                
            }
    }
}

//struct OpenRemoteBtn_Previews: PreviewProvider {
//    static var previews: some View {
//        OpenRemoteBtn()
//    }
//}
