//
//  CloseBtn.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/11.
//

import SwiftUI

struct CloseBtn: View {
    var body: some View {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.accentColor)
                .opacity(0.8)
                .scaleEffect(1.2)
               
 
    }
}

struct CloseBtn_Previews: PreviewProvider {
    static var previews: some View {
        CloseBtn()
            .previewLayout(.sizeThatFits)
    }
}
