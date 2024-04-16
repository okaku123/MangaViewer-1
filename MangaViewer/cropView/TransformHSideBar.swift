//
//  TransformHSideBar.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/2.
//

import SwiftUI
import PositionScrollView

struct TransformHSideBar : View  , PositionScrollViewDelegate{
    
    @Binding var value : CGFloat
    
    func onChangePage(page: Int) {
        
    }
    
    func onChangePosition(position: CGFloat) {
        value =  -( position - 300 )
        print(value)
        
    }
    
    func onScrollEnd() {
        
    }
    
    let generator = UINotificationFeedbackGenerator()
    
    @ObservedObject var myViewModel = PositionScrollViewModel(pageSize: CGSize(width: 30, height: 10),
                                                              verticalScroll : Scroll(scrollSetting: ScrollSetting(pageCount: 60, initialPage: 30 , unitCountInPage: 1, afterMoveType: .momentum, scrollSpeedToDetect: 2 ), pageLength: 10)
        )
        
    public var body: some View {
        return
            
//            VStack{
//
                VStack {
                    PositionScrollView(
                        viewModel: self.myViewModel ,
                        delegate: self
                    ) {
                        VStack( alignment: .trailing, spacing: 0 ) {
                            ForEach(0...60, id: \.self){ i in
                                VStack{
                                    Rectangle()
                                        .fill( ( i % 5) == 0 ? Color.blue : Color.blue.opacity(0.7))
                                        .frame( width: (i % 5) == 0 ? 30 : 20 , height: 1 )
                                }
                                .frame(height: 10 )
                                .background(Color.white.opacity(0.01))
                                .onDisappear{
                                    UISelectionFeedbackGenerator().selectionChanged()
                                }
                            }
                            
                        }
                    }
                    
                }
                .frame(width:30 , height: 350 )
                .clipped()
                
//
//                Text("page: \(self.myViewModel.horizontalScroll?.page ?? 0)")
//                Text("position: \(self.myViewModel.horizontalScroll?.position ?? 0)")
//                Text("value: \(self.value)")
//            }
//            .foregroundColor(.blue)
        
    }
}


struct TransformSideBar_Previews: PreviewProvider {
    
     @State static var value : CGFloat = 0
    
    static var previews: some View {
        TransformHSideBar(value: $value ) 
//        TransformVSideBar(count: 57)
            .previewLayout(.sizeThatFits)
            .padding()
    }

}
