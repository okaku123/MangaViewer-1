//
//  DetailsView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
struct DetailsView : View {
    
    let picture: Picture
    @State var navBarHidden: Bool = false
    @State var imagesList : [PicModelObject]
    
    @State private var showingSheet = false
    
    var body: some View{
        //        VStack(alignment: .leading) {
        //            WebImage(url: URL(string: picture.urls.small))
        //                .resizable()
        //                .aspectRatio(contentMode: .fill)
        //                .cornerRadius(14)
        //                .clipped()
        //               }
        //               .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        
        MyCollectionView(imagesList: imagesList)
            .navigationBarTitle(Text(picture.id), displayMode: .inline)
//            .navigationBarHidden(true)
            .navigationBarHidden(self.navBarHidden)
//            .statusBar(hidden: self.navBarHidden)
            .animation(.linear(duration: 0.15))
            .onTapGesture {
                self.navBarHidden.toggle()
            }
            .edgesIgnoringSafeArea([.top, .bottom])
            .navigationBarItems(
                           trailing: Button(action: {
                                self.showingSheet.toggle()
                           }){
                                Image(systemName: "plus.circle")
                           }
                           .sheet(isPresented: $showingSheet) {
                                _SettingsView()
                            }
                            .accentColor( .white ))
        
           
        
//            .statusBar(hidden: true)
//            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//                       self.navBarHidden = true
//                   }
//            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//                       self.navBarHidden = false
//                   }
//            .navigationBarItems(
//                leading: Button(action: { }) { Image(systemName: "plus.circle")}.accentColor(.red),
//                trailing: Button("Settings",action: { }).accentColor(.red))
            
        
        
    }
}



struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let pic = Picture(id: UUID().uuidString, alt_description: nil, urls: PictureUrl(full: "", small: "", thumb: ""))
        DetailsView(picture:  pic , imagesList: [] )
    }
}


