//
//  HUD2.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/8/19.
//

import SwiftUI

struct HUD2: View {
    //   @State var dismissHandler : ((Bool) -> Void)? = nil
        
        @EnvironmentObject var hudManager : HUDManager
        @Binding var title : String
        @Binding var icon : String
        @State var HUDOffset : CGFloat = -100

        @ViewBuilder var body: some View {
//            Text("\(title)")
            Label("\(title)", systemImage: "\(hudManager.icon)") 
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
                .padding(14)
                .background(
                    Blur(style: .systemMaterial)
                        .clipShape(Capsule())
                        .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
                )
                .offset(y: HUDOffset )
                .onAnimationCompleted(for: HUDOffset){
                    let result = hudManager.show
                    if !result{
                        hudManager.dismissHandler?( result )
                    }
                    hudManager.timer = Timer.scheduledTimer(withTimeInterval: 2.0 ,
                                                            repeats: false){ _ in
                        guard  hudManager.show  else { return }
                        DispatchQueue.main.async {
                            self.hudManager.show = false
                        }
                    }
                    
                }
                .onChange(of: hudManager.show ){ show in
                    withAnimation(.easeInOut){
                        HUDOffset = show ? 0 : -100
                    }
                }
        }
}

struct HUD2_Previews: PreviewProvider {
    
   @State static var title = "HUD"
    @State static var icon = "photo"
    @StateObject static var hudMangaer = HUDManager()
    static var previews: some View {
        HUD2(title: $title, icon: $icon)
            .environmentObject( hudMangaer )
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
