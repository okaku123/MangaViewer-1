//
//  CircleLable.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/30.
//

import Foundation
import SwiftUI

struct JumpSetcionSideBar : View {
    
    @State var count  : Int = 0
    var proxy : ScrollViewProxy? = nil
//    var model : BookSelfModel
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
                VStack{
                    ScrollView(showsIndicators: false ){
                        LazyVStack(spacing: 15 ){
                            ForEach( 0 ..< count ){ i in
                                Text("\(i + 1 )")
                                    .frame(width: 20, height: 20)
                                    .font(.footnote)
                                    .onTapGesture {
                                        
                                        self.generator.notificationOccurred(.success)
                                        
                                        print("\(i)")
                                        if let p = self.proxy {
                                            print("jumo to \(i )")
//                                            model.getPage( i + 1 )
                                            //不挑到cell 的话 cell不会刷新
                                            //跳到setcion 的话 cell 不会刷新
                                            // cell和setion都可以用.id 修改器添加id
                                            //不手动添加的话会自动用ForEach中提供的id
                                            //手动设置id可以覆盖ForEach中的id ，id是一个hashable ，可以用字符串
                                            p.scrollTo( "\(i)-0"  , anchor: .top)
                                        
                                        }
                                    }
                                    .onDisappear{
                                        print("...")
                                        UISelectionFeedbackGenerator().selectionChanged()

                                    }
                              
                            }
                        }.padding([.top , .bottom], 15)
                    }
                }
                .frame(width: 20, height: 300, alignment: .center)
//                .background(Color.white)
         
    }
}
struct JumpSetcionSideBar_Previews: PreviewProvider {
    static var previews: some View {
//        JumpSetcionSideBar()
        Spacer()
    }
    
}

