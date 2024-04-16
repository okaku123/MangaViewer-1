//
//  NukePage.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/8.
//

import SwiftUI
import NukeUI

//MARK: 图片遮盖 -
struct ImageDarkMask : View {
    
    @Binding var style : MaskStyle
    @State var size : CGSize = .zero
    
    var body: some View{
        
        if style == .none {
                Rectangle()
                    .frame(width: size.width, height: size.height)
        }else if style == .little{
            Rectangle()
                .frame(width: size.width, height: size.height)
                .background(Color.black)
                .opacity(0.9)
        }else if  style == .medium{
            Rectangle()
                .frame(width: size.width, height: size.height)
                .background(Color.black)
                .opacity(0.7)
            
        }else if style == .deep{
            Rectangle()
                .frame(width: size.width, height: size.height)
                .background(Color.black)
                .opacity(0.5)
        }else {
                Rectangle()
                    .frame(width: size.width, height: size.height)
        }
    }
}

enum MaskStyle {
    case none
    case little
    case medium
    case deep
}

//MARK: 页面 -
struct NukePage: View {
    
    @State  var urlString : String = ""
    
    var url : URL?{
        URL(string: urlString)
    }
//    @Binding var maskStyle : MaskStyle
    
    @State var alltrue = true
    
    var body: some View {
        VStack{
        if  let _url = url {
            LazyImage(source: _url  ) { state in
                if let image = state.image {
    
//                    image
//                        .resizingMode(.aspectFit)
//                        .onAppear{
//                            print(state.imageContainer?.image.size)
//                            print(state.imageContainer?.image.scale)
//                        }
   
                
//                            image
//                        .resizingMode(.center)
//                              .frame( width: state.imageContainer!.image.size.width ,  height: state.imageContainer!.image.size.height )
                  
                    
                    image
                        .resizingMode(.aspectFit)
                    
                } else if state.error != nil {
                    Text("error")
                        .foregroundColor(.white)
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .foregroundColor(Color.white)
                        .scaleEffect(2)
                }
            }

                
//                .mask( ImageDarkMask(style: maskStyle , size: CGSize( width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ) ) )
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct NukePage_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
//        NukePage()
    }
}
