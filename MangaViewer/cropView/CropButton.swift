//
//  CropButton.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/13.
//

import SwiftUI

struct CropButton: View {
    
    @State var isClick = false
    @State var handle : (()->())? = nil
    
    var body: some View {
        VStack{
        Image(systemName: "slider.horizontal.below.rectangle")
            .foregroundColor(  isClick ? .blue : .black )
        }.background(
                Circle()
                    .fill(Color.white)
                    .opacity( isClick ? 0.7 : 1.0 )
                    .frame(width: 40 , height: 40)
                    .scaleEffect( isClick ?  1.2 : 1.0 )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 0)
//                    .animation(.spring())
            )
            .onTapGesture {
                withAnimation(.spring()){
                    isClick.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.125){
                    withAnimation(.spring()){
                    self.isClick.toggle()
                    }
                    self.handle?()
                }
            }
    }
}

struct CropButton_Previews: PreviewProvider {
    static var previews: some View {
        CropButton{
            print("..")
        }
    }
}
