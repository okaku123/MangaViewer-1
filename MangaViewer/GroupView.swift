//
//  DetailsView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
struct GroupView : View {
    
    
   
    
    @EnvironmentObject var partialSheet: PartialSheetManager
  
    @State var name = ""
    @State var bookNameList = [String]()
    //    @State var bookList = [Book]()
    @State var cellPressList : [Bool] = {
        var list = [Bool]()
        for _ in 0 ..< 30 {
            list.append(false)
        }
        return list
    }()
    
    @State private var selection: String? = nil
    
    var colums = [
        GridItem(spacing: 0 ),
        GridItem(spacing: 0)
    ]
    
    
    @Binding var showMenuBtn : Bool
    var body: some View{
        
        if !bookNameList.contains(name){
            Text("load...")
                .navigationBarTitle( name , displayMode: .inline)
                .onAppear{
                    self.bookNameList.append(name)
                    cellPressList = Array(repeating: false, count: bookNameList.count)
                }
        }else{
            
            GeometryReader{ geo in
                
                let beforeWidth =  ( geo.size.width - 20 * 3 ) / 2
                let afterWidth = beforeWidth * 0.9
                let beforeHeight =  ( geo.size.width - 20 * 3 ) / 2 * 1.3
                let afterHeight = beforeHeight * 0.9
                
                VStack{
                    ScrollView {
                        LazyVGrid(columns: colums, spacing: 20 ) {
                            ForEach( 0 ..< self.bookNameList.count , id: \.self ){ i in
                                let name =  self.bookNameList[i]
                                let url = "\(serverUrl)/getCover/\(name.replacingOccurrences(of: ".zip", with: ".jpg").urlEncoded() )"
                                let width = !cellPressList[i] ? beforeWidth : afterWidth
                                let height = !cellPressList[i] ? beforeHeight : afterHeight
                                
                                NavigationLink( destination: _NewDetailsView(name : name
                                                                             ,showMenuBtn : $showMenuBtn
                                                                            ).environmentObject(sheetManager) , tag : "\(i)" , selection : $selection ){
                                    
                                    VStack{
                                        WebImage(url: URL(string: url ))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: width , height: height )
                                            .cornerRadius(8)
                                            .clipped()
                                            .animation(.easeIn(duration: 0.12))
                                    } .onTapGesture {
                                        withAnimation(.spring()){
                                            cellPressList[i] = true
                                        }
                                        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                            withAnimation(.spring()){
                                                cellPressList[i] = false
                                            }
                                            Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                                self.selection = "\(i)"
                                            }
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                        }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        
                    }
                }
                .onAppear{
                    showMenuBtn = false
                }
                .navigationBarTitle( name , displayMode: .inline)
            }
        }
        
        
    }
}


//
//struct GroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        NavigationView{
//            GroupView(name : "(C94) [ヌルネバーランド (ナビエ遥か2T)] デリ☆サキュ!! vol.2.0 ～デリヘル呼んだらサキュバス3人に喰べ尽くされたレポ～ (オリジナル) [DL版].zip"
//                     , bookNameList: ["(C93) [ヌルネバーランド (ナビエ遥か2T)] デリ☆サキュ!! -デリヘル読んだらサキュバスが来たレポ- (オリジナル).zip"] )
//        }
//        .previewDevice("iPhone 8 Plus")
//    }
//}
//

