//
//  CropContextView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/7.
//

import Combine
import Foundation
import SwiftUI
import SDWebImageSwiftUI
import UIKit
import SwiftUIPager
import Alamofire

struct CropContextView: View {
    
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    
    @EnvironmentObject var partialSheet: PartialSheetManager
    
    @ObservedObject var lastReadModel : LastReadModel = LastReadModel()
    
    var sheetStyle = PartialSheetStyle(background: .blur(.systemMaterialDark),
                                          handlerBarColor: Color(UIColor.systemGray2),
                                          enableCover: false,
                                          coverColor: Color.clear,
                                          blurEffectStyle:  .systemChromeMaterial,
                                          cornerRadius: 10,
                                              minTopDistance: UIScreen.main.bounds.height / 2  )
    
    var name : String = ""
    
    @ObservedObject var model = CropedModel()
    @State var currentIndex : Int = 0
    @State private var page: Page = .first()
    @State private var showSetting = true
    
    
    @State var sideALeftOffset : CGFloat = 0
    @State var sideALeftWidth : CGFloat = 1
    @State var sideBLeftOffset : CGFloat = 0
    @State var sideBLeftWidth : CGFloat = 1
    @State var lastReadCount : Int = 0
    
    var body: some View {
        
        VStack{
            if model.imagesList.isEmpty { 
                    ProgressView("Loading…")
                    .onAppear{
                            _ = PageSizeModel(name: name){ count in
                                model.setPage(name, count: count)
                            }
                        }
                }else{
                    Pager(page: page, data: model.pageIndexList , id: \.self ){ index in
                        CropedMangaPage(urlString: model.imagesList[index].url! ,
                                        count: index ,
                                        totalCount: model.pageIndexList.count ,
                                        sideALeftOffset: $sideALeftOffset ,
                                        sideALeftWidth: $sideALeftWidth ,
                                        sideBLeftOffset: $sideBLeftOffset ,
                                        sideBLeftWidth: $sideBLeftWidth
                                        )
                        
                    }
                    .onPageChanged{ i in
                        self.currentIndex = i
                    }
                    .itemSpacing(20)
                    .horizontal()
                    .edgesIgnoringSafeArea(.bottom)
                    .background(Color.black)
                }
        }
        ///注册modal 风格
        .addPartialSheet(style: sheetStyle)
        .partialSheet(isPresented: $showSetting ) {
            MangaPageModView(selectedTab: "0" , cropImageUrl: "" )
        }
        
        .onAppear{
            if !jobConnectionManager.isReceivingJobs{
                jobConnectionManager.isReceivingJobs = true
            }
            
           listenRemote()
           ///找到上次阅读位置
            lastReadCount = lastReadModel.find(name)
            
            
            
        }
        .onDisappear{
            /// 保存阅读位置
            lastReadModel.save(name: name , count: currentIndex)
        }
        .onChange(of: showSetting ){showSetting in
            if !showSetting {
                listenRemote()
            }
        }
        
        .navigationBarItems(
                trailing:
                    Button(action: {
                        showSetting.toggle()
                    }) {
                        Label("裁剪", systemImage: "square.dashed.inset.fill")
                    }
        )
     
        
    }
    
    
    ///监听远程设备
    private func listenRemote(){
        jobConnectionManager.jobReceivedHandler = { msg in
            if msg == "circle" {
                showSetting.toggle()
            }
        }
    }
    
    
    
    
}
