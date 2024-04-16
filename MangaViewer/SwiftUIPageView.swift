
import SwiftUI
import SwiftUIPager
import UIKit
import NukeUI

let cellWidth = UIScreen.main.bounds.size.width
let cellHeight = UIScreen.main.bounds.size.height
let maxCellSizw = CGSize(width: cellWidth, height: cellHeight)

struct SwiftUIPageView: View {
    
    @State var imagesList : [ MangaPageObject ] = []
    @State var totalPageCount = 0
    @State var pageIndex = 0
    
    @StateObject var page: Page = .first()
    
    var body: some View {
        
        VStack{
            if !imagesList.isEmpty {
                Pager(page: self.page,
                      data: self.imagesList,
                      id: \.id ,
                      content: { index in
                        pageView(0)
                      })
                    .itemSpacing(20)
                    .sensitivity(.high)
                    .horizontal(.leftToRight)
                
                
            }
        }.onAppear{
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){_ in
                
                self.imagesList.append(MangaPageObject(url: "" ))
                self.imagesList.append(MangaPageObject(url: "" ))
                self.imagesList.append(MangaPageObject(url: "" ))
                self.imagesList.append(MangaPageObject(url: "" ))
                self.totalPageCount = self.imagesList.count
            }
            
            
            
            
            //           _ = UnsplashTextPictrueModel{ result in
            //                var tmpUrlList = [MangaPageObject ]()
            //                for i in 0 ..< result.count {
            //                    let url = result[i]
            //                    tmpUrlList.append( MangaPageObject(url: url) )
            //                }
            //                imagesList.append(contentsOf: tmpUrlList)
            //
            //                self.totalPageCount = imagesList.count
            //            }
            
        }
        
    }
    
    
}


func pageView(_ index : Int) -> some View {
    VStack{
        Text("\(index)")
    }
    .frame(width: cellWidth, height: cellHeight)
    .background(Color.yellow)
}

//struct SwiftUIPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIPageView()
//    }
//}

struct CatsGalleryView: View {
    
    @State var imagesList : [ MangaPageObject ] = []
    @State var imagesScaleList : [ CGFloat ] = []
    @State var currentIndex = 0
    @GestureState var scale: CGFloat = 1.0
    
    @State private var page: Page = .first()
    //    @Environment(\.imageCache) private var cache: ImageCache
    
    @State var dragging = false
    
    var data = Array(0..<30)
    var body: some View {
        NavigationView {
            if imagesList.isEmpty {
                ProgressView()
            } else {
                Pager(page: page, data: data , id: \.self ) { index in
                    let url = imagesList[index].url!
                    let scale = imagesScaleList[index]
                    PageView(url: url  , toScale: $imagesScaleList[index]  , dragging : $dragging )
                }.onPageChanged{ i in
                    self.currentIndex = i
                }
                .itemSpacing(20)
                .gesture(
                    MagnificationGesture(minimumScaleDelta: 0)
                        .updating($scale, body: { (value, scale, trans) in
                            if value.magnitude < 0.9 {
                                scale = 1.0
                            }else{
                                scale = value.magnitude
                            }
                            self.imagesScaleList[self.currentIndex] = scale
                        })
                )
//                .gesture(MagnificationGesture())
                .background(Color.black)
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitle("Cats Gallery", displayMode: .inline)
                
                
            }
        }.onAppear{
            
            let url = "https://images.unsplash.com/photo-1622820372091-a9141e64ae79?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&dl=eberhard-grossgasteiger-TqlLqNwNDIM-unsplash.jpg&w=640"
            
            for _ in 0...30 {
                self.imagesList.append( MangaPageObject(url: url ) )
            }
            imagesScaleList = Array(repeating: 1.0 , count: 30 )
            
            
            //            _ = UnsplashTextPictrueModel{ result in
            //                          var tmpUrlList = [MangaPageObject ]()
            //                          for i in 0 ..< result.count {
            //                              let url = result[i]
            //                              print(url)
            //                              tmpUrlList.append( MangaPageObject(url: url) )
            //                          }
            //                    imagesList.append(contentsOf: tmpUrlList)
            //            }
        }
    }
}


struct PageView : View   {
    
    @State var url : String
    @Binding var toScale : CGFloat
    @Binding var dragging : Bool
    
    var body: some View{
        VStack{
            LazyImage(source: URL(string : url )! )
        
        }
        
    }
    
}

struct CatsGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        CatsGalleryView()
    }
}


