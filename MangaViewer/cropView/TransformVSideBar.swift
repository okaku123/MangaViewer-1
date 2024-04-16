//
//  TransformVSideBar.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/2.
//

import SwiftUI
import PositionScrollView

struct TransformVSideBar : View  , PositionScrollViewDelegate{
    
    @Binding var value : CGFloat
    
    func onChangePage(page: Int) {
        
    }
    
    func onChangePosition(position: CGFloat) {
        value = position - 300
        
    }
    
    func onScrollEnd() {
        
    }

    let generator = UINotificationFeedbackGenerator()

    @ObservedObject var myViewModel = PositionScrollViewModel(pageSize: CGSize(width: 10, height: 30),
        horizontalScroll: Scroll(scrollSetting: ScrollSetting(pageCount: 60, initialPage: 30 , unitCountInPage: 1, afterMoveType: .fitToNearestUnit, scrollSpeedToDetect: 30), pageLength: 10),
        verticalScroll: nil)
        
        public var body: some View {
            return VStack {
                PositionScrollView(
                    viewModel: self.myViewModel ,
                    delegate: self
                ) {
                    HStack( alignment : .bottom ,  spacing: 0) {
                        ForEach(0...60, id: \.self){ i in
                            VStack{
                            Rectangle()
                                .fill(  Color.blue )
                               .frame(width: 2 , height: (i % 5) == 0 ? 30 : 20  )
                            }.frame(width: 10)
                            .background(Color.white.opacity(0.01))
                            .onDisappear{
                                UISelectionFeedbackGenerator().selectionChanged()
                            }
                        }
                        
                    }
                }
//                Text("page: \(self.myViewModel.horizontalScroll?.page ?? 0)")
//                Text("position: \(self.myViewModel.horizontalScroll?.position ?? 0)")
//                Text("value: \(self.value)")
            }
            .frame(width:250)
            .clipped()
            .foregroundColor(.blue)
            
        }
}
