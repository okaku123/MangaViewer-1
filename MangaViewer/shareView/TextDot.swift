//
//  TextDot.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/8/9.
//

import SwiftUI

struct TextDot: View {
    var body: some View {
        Circle()
            .frame(width:5)
            .foregroundColor(.black)
    }
}

struct TextDot_Previews: PreviewProvider {
    static var previews: some View {
        TextDot()
    }
}
