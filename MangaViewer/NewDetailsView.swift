//
//  DetailsView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import UIKit
import Nuke



struct NewDetailsView : View {
    
    @EnvironmentObject var partialSheet: PartialSheetManager
    
    let sheetStyle = PartialSheetStyle(background: .blur(.systemMaterialDark),
                                          handlerBarColor: Color(UIColor.systemGray2),
                                          enableCover: false,
                                          coverColor: Color.clear,
                                          blurEffectStyle:  .systemChromeMaterial,
                                          cornerRadius: 10,
                                          minTopDistance: 110)
    
    

    @State var isSheetShown = false
    var name : String = ""
    @State var navBarHidden: Bool = false
    @State var imagesList : [ MangaPageObject ] = []
    @State var showingSheet = false
    
    @State var currentPage : Int = 0
    @State var jumpPageCount : Int = -1
    @State var jumpToggle : Bool = false
    
    @State var totalPageCount = 0
    
    
    @ObservedObject var lastReadModel : LastReadModel = LastReadModel()
    
    var body: some View{
        
        if imagesList.isEmpty {
            VStack{
                ProgressView("Loading…")
            }
            .onAppear{
                print(name)
                
                // 办公室测试环境 使用 Unsplash 源
//                UnsplashTextPictrueModel{ result in
//                    var tmpUrlList = [MangaPageObject ]()
//                    for i in 0 ..< result.count {
//                        let url = result[i]
//                        tmpUrlList.append( MangaPageObject(url: url) )
//                    }
//                    imagesList.append(contentsOf: tmpUrlList)
//
//                    self.totalPageCount = imagesList.count
//                }
                
                                _ = PageSizeModel(name: name){ count in
                                    var tmpUrlList = [MangaPageObject ]()
                                    for i in 0 ..< count {
                                        let url = "\(serverUrl)/getPage?name=\(name.urlEncoded())&index=\(i)"
                                        tmpUrlList.append( MangaPageObject(url: url) )
                                    }
                                    imagesList.append(contentsOf: tmpUrlList)
                                    self.totalPageCount = count
                                }
            }
            .navigationBarTitle(Text("manga"), displayMode: .inline)
        }else{
            NewCollectionView(imagesList: imagesList, currentPageCount: $currentPage, jumpPageCount: $jumpPageCount, jumpToggle: $jumpToggle)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .navigationBarTitle(Text(name), displayMode: .inline)
                .navigationBarHidden(self.navBarHidden)
                .animation( .easeInOut(duration: 0.16) )
                .onTapGesture {
                    self.navBarHidden.toggle()
                }
                .navigationBarItems(
                    trailing:
                        HStack(alignment: .center, spacing: 5){
                             let count = self.lastReadModel.find(name)
//                            let count = 2
                            if count > 0 {
                                CapsuleLable(text: "Option")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        self.isSheetShown = true
                                    }
                                Spacer(minLength: 0)
                                Button(action: {
                                    self.jumpPageCount = count
                                    if self.jumpToggle{
                                        self.jumpToggle = false
                                    }
                                    self.jumpToggle = true
                                    Timer.scheduledTimer(withTimeInterval: 0.16, repeats: false){_ in
                                        self.jumpToggle = false
                                    }
                                }){
                                    CircleLableView(text: "\(count + 1)")
                                }.frame(width: 28 , height: 28)
                            }else{
                                Spacer()
                            }
                        }
                )
                .onChange(of:  jumpPageCount , perform: {jumpPageCount in
                    print(jumpPageCount)
                })
                .addPartialSheet(style: self.sheetStyle)
            
                .onDisappear{
                    print( "onDisappear-> \(self.currentPage)")
                    self.lastReadModel.save(name: name , count: currentPage)
//                    print(lastReadModel.lastReadSave)
                }
                .partialSheet(isPresented: $isSheetShown) {
                    ControllView(total: totalPageCount, jumpPageCount: $jumpPageCount , jumpToggle: $jumpToggle )
                }
        }
        
    }
}




let sheetManager: PartialSheetManager = PartialSheetManager()

struct NewDetailsView_Previews: PreviewProvider {
    
   
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    static var previews: some View {
        
        NavigationView {
            NewDetailsView( name: "test Manga "   )
                .addPartialSheet()
//                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(sheetManager)
               
        }
        .preferredColorScheme(.dark)
    }
}


struct HealthGroupBoxStyle: GroupBoxStyle {
    var color: Color

    @ScaledMetric var size: CGFloat = 1
    
    func makeBody(configuration: Configuration) -> some View {
      
            GroupBox(label: HStack {
                configuration.label.foregroundColor(color)
                
                Spacer()
            }) {
                configuration.content.padding(.top)
            }
      
    }
}

struct HealthValueView: View {
    var value: String
    var unit: String
    
    @ScaledMetric var size: CGFloat = 1
    
    @ViewBuilder var body: some View {
        HStack {
            Text(value).font(.system(size: 24 * size, weight: .bold, design: .rounded)) + Text(" \(unit)").font(.system(size: 14 * size, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
            Spacer()
        }
    }
}


struct ControllView: View {

    @State var total : Int 
    @Binding var jumpPageCount : Int
    @Binding var jumpToggle : Bool
    @State  private var current: Double = 1
    

    var body: some View {
                      VStack(spacing: 8) {
                          GroupBox(label: Label("Jump to page", systemImage: "forward.fill")) {
                            HStack{
                                HealthValueView(value: "\(Int(current) + 1 )" , unit: "\(total)" )
                                    .frame(minWidth: 30, idealWidth: 30, maxWidth: 75, minHeight: 18, idealHeight: 18, maxHeight: 18, alignment: .leading)
                                Slider(value: $current , in: 0...Double(total - 1) , step: 1 ){ b in
                                    if !b {
                                        self.jumpPageCount = Int(current)
                                        if self.jumpToggle{
                                            self.jumpToggle = false
                                        }
                                        self.jumpToggle = true
                                        Timer.scheduledTimer(withTimeInterval: 0.16, repeats: false){_ in
                                            self.jumpToggle = false
                                        }
                                    
                                    }
                                }
                            }
                           
                          }.groupBoxStyle(HealthGroupBoxStyle(color: .blue))
                          .onTapGesture {
                            
                          }
                        
                        HStack( spacing: 8){
                            GroupBox(label: Label("Jump Last 5", systemImage: "backward")) {
                            }.groupBoxStyle(HealthGroupBoxStyle(color: .blue))
                            .onTapGesture {
                                self.jumpPageCount -= 5
                                if jumpPageCount < 0 {
                                    jumpPageCount = 0
                                }
                                if self.jumpToggle{
                                    self.jumpToggle = false
                                }
                                self.jumpToggle = true
                                Timer.scheduledTimer(withTimeInterval: 0.16, repeats: false){_ in
                                    self.jumpToggle = false
                                }
                                
                            }
                            
                            GroupBox(label: Label("Jump Next 5", systemImage: "forward")) {
                            }.groupBoxStyle(HealthGroupBoxStyle(color: .blue))
                            .onTapGesture {
                                self.jumpPageCount += 5
                                if jumpPageCount > total {
                                    jumpPageCount = total
                                }
                                if self.jumpToggle{
                                    self.jumpToggle = false
                                }
                                self.jumpToggle = true
                                Timer.scheduledTimer(withTimeInterval: 0.16, repeats: false){_ in
                                    self.jumpToggle = false
                                }
                                
                            }
                        }
                        
                        
                        
                        
                      }
                      .padding()
                      .background(Color(.secondarySystemBackground))
                      .edgesIgnoringSafeArea(.bottom)
                     
    
    }
}
