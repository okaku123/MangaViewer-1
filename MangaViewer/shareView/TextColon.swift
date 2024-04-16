//
//  TextColon.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/8/9.
//

import SwiftUI

struct TextColon: View {
    var body: some View {
        VStack{
            Circle()
                .frame(width:5)
                .foregroundColor(.black)
                
            Circle()
                .frame(width:5)
                .foregroundColor(.black)
        }.frame(height:15)
    }
}

struct TextColon_Previews: PreviewProvider {
    static var previews: some View {
        TextColon()
    }
}
