//
//  CircleLable.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/30.
//

import Foundation
import SwiftUI

struct CircleLableView: View {
    @State var text : String = "0"
    var body: some View {
            ZStack{
                Circle()
                    .foregroundColor(.blue)
                Text(text)
                    .foregroundColor(.white)
                    .font(.footnote)
            }.frame(minWidth: 20, idealWidth: 28, maxWidth: 38, minHeight: 20, idealHeight: 28, maxHeight: 38, alignment: .center)
           
    }
}
struct CircleLableView_Previews: PreviewProvider {
    static var previews: some View {
        CircleLableView(text : "9")
    }
    
}

