//
//  CapsuleLable.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/5/31.
//

import Foundation
import SwiftUI
import UIKit

struct CapsuleLable : View {
    
    @State var text  = "Lable"
   
    var body: some View {
            ZStack{
                Capsule()
                    
                Text(text)
                    .foregroundColor(.white)
                    .font(.footnote)
            }.frame(width: text.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).width + 20 , height: 28 , alignment: .center)
        }
    
}

struct CapsuleLable_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleLable(text: "Lable...")
    }
    
    
}
