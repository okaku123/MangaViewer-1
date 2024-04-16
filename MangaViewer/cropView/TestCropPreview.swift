//
//  TestCropPreview.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/4.
//

import SwiftUI

struct TestCropPreview : View {
    
    @State var imageWidth : CGFloat = 0
    @State var imageHOffset : CGFloat = 0
    @State var imageVOffset : CGFloat = 0
    
    @State var uiimage : UIImage? = nil
    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                VStack{
                    if  let image = uiimage{
                        Image(uiImage: image )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .frame( width: geo.size.width )
                    }
                }.frame(width: geo.size.width , height: geo.size.height )
                    .background(Color.gray)
            }
        }
        .onAppear{
            let image =  UIImage(named: "test")!
            let width = Double( image.cgImage!.width )
            let height = Double( image.cgImage!.height )
            //            0.15816073874498524
            //            0.3960396039603961
            if let cgImage = image.cgImage?.cropping(to: CGRect(x:  0.104 * width , y: 0 ,
                                                                width: 0.3947 * width , height: height )) {
                uiimage = UIImage(cgImage: cgImage)
                
            }
   
        }
    }
}

struct TestCropPreview_Previews: PreviewProvider {
    static var previews: some View {
        TestCropPreview()
    }
}
