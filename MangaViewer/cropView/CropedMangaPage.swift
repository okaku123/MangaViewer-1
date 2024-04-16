//
//  CropedMangaPage.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/7.
//

import SwiftUI
import NukeUI
import Nuke
import UIKit
import Foundation
import SuperResolutionKit 

struct CropInfo {
    var left : Double  = 0
    var width : Double = 0
}


struct CropedMangaPage: View {
    
    @State  var urlString : String = ""
    
        var url : URL?{
            URL(string: urlString)
        }
    
    @State var count : Int = 0
    @State var totalCount : Int = 0
    
    ///办公室调试环境
//    var url : URL?{
//        URL(string: UnsplashUrlArray.first! )
//    }
    
    @State var cropA = true
    @State var cropB = false
    @State var image : UIImage? = nil
    
    //裁剪比率
    @Binding var sideALeftOffset : CGFloat
    @Binding var sideALeftWidth : CGFloat
    @Binding var sideBLeftOffset : CGFloat
    @Binding var sideBLeftWidth : CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                if let img = image {
                    Image(img)
                        .frame(width: geo.size.width)
                }else{
                    ProgressView("loading")
                }
                VStack{
                    Spacer()
                    Text("\(self.count + 1 )/\(self.totalCount)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .onAppear{
            
            let request = ImageRequest(url: url!)
            let cache = ImagePipeline.shared.cache
            let cacheImage = cache.cachedImage(for: request)?.image
            if cacheImage != nil {
                self.image = cacheImage
                return
            }
            ImagePipeline.shared.loadData(with: request
                                          , completion:  { result in
                                            if let _result = try? result.get()  ,
                                               let url = _result.response?.url?.absoluteString ,
                                               let org = UIImage(data: _result.data){
                                                
                                                let type : String = ( url.last == "A" || url.last == "B" ) ? ( url.last == "A" ? "A" : "B" ) : "N"
                                                var cropLeft : CGFloat
                                                var cropWidth : CGFloat
                                                switch type {
                                                case "A":
                                                    cropLeft = sideALeftOffset
                                                    cropWidth = sideALeftWidth
                                                    break
                                                case "B":
                                                    cropLeft = sideBLeftOffset
                                                    cropWidth = sideBLeftWidth
                                                    break
                                                case "N":
                                                    self.image = org
                                                    cache.storeCachedData(image!.jpegData(compressionQuality: 1.0 )!, for: request)
                                                    return
                                                default:
                                                    return
                                                }
                                                let width = CGFloat( org.cgImage!.width )
                                                let height = CGFloat( org.cgImage!.height )
                                                
                                                if let cgImage = org.cgImage?.cropping(to:
                                                                                        CGRect(x:  cropLeft * width ,
                                                                                               y: 0 ,
                                                                                               width: cropWidth * width ,
                                                                                               height: height )){
                                                    self.image = UIImage(cgImage: cgImage)
                                                    cache.storeCachedData(image!.jpegData(compressionQuality: 1.0 )!, for: request)
                                                }
                                }
                                            
                      })
            }
    }
    
}

//struct CropedMangaPage_Previews: PreviewProvider {
//    static var previews: some View {
//        CropedMangaPage()
//    }
//}

class MyImageProcessing : ImageProcessing {
    
    var cropInfo : CropInfo
    
    init(_ cropInfo : CropInfo){
        self.cropInfo = cropInfo
    }
    
    func process(_ image: PlatformImage) -> PlatformImage? {
        
        let width = Double( image.cgImage!.width )
        let height = Double( image.cgImage!.height )
        //        print(width)
        let l = cropInfo.left
        let w = cropInfo.width
        
        //        print("--\( image.cgImage?.width ) \(image.cgImage?.height )--")
        
        if let cgImage = image.cgImage?.cropping(to: CGRect(x:  l * width ,
                                                            y: 0 ,
                                                            width: w * width ,
                                                            height: height )) {
            let result = UIImage(cgImage: cgImage)
            
            return result
        }
        return nil
    }
    
    var identifier: String = "\(UUID())"
    
}



//                LazyImage(source: _url  ) { state in
//
//                    if let image = state.image {
//                        image
////                            .resizingMode(.aspectFit)
//                        //                        .resizingMode(.aspectFit)
//                    } else if state.error != nil {
//                        Text("error")
//                            .foregroundColor(.white)
//                    } else {
//                        ProgressView()
//                            .progressViewStyle(.circular)
//                            .foregroundColor(Color.white)
//                            .scaleEffect(2)
//                    }
//                }
//                .onSuccess { res in
//
//                    if let url = res.urlResponse?.url?.absoluteString ,
//                       let sideType = url.last  {
//                        if sideType == "A" {
//                            cropA = true
//                            cropB = false
//                        }else if sideType == "B" {
//                            cropA = false
//                            cropB = true
//                        }
//                    }
//                }
//
//                .if( cropA, else: cropB){ view in
//                    view.processors([
//                        processingA
//                    ])
//                } done: { view in
//                    view.processors([
//                        processingB
//                    ])
//                }
