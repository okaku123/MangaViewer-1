//
//  MangaViewerApp.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import SwiftUI

@main
struct MangaViewerApp: App {
    
    @State var selectedTab = "0"
    
    @StateObject var jobConnectionManager = JobConnectionManager()
    @StateObject var showMeunContext = ShowMeunContext()
    @State var fake : Bool = false
    
    @StateObject var hudMangaer = HUDManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            
            let sheetManager: PartialSheetManager = PartialSheetManager()
            //            let jobConnectionManager = JobConnectionManager()
            
            
            //            ShareContextView(showMenuBtn: $fake)
            //                .environmentObject(sheetManager)
            //                .environmentObject(jobConnectionManager)
            
            //            RemoteControllerView()
            //                .environmentObject(sheetManager)
            //
            //            ShareBookCellPreview()
            
            //            VStack{
            //            swipeGesture{ direction in
            //                print(">>>")
            //                print(direction)
            //            }.background(Color.blue)
            //
            //            }
            
            
            //            SimpleContextView()
            
//                        VideoHelpView()
            
            ScreenComet()
        
            //临时注释掉 正常使用
//                        _ContentView()
//                            .environmentObject(sheetManager)
//                            .environmentObject(jobConnectionManager)
//                            .environmentObject(hudMangaer)
//                            .environmentObject(showMeunContext)
            
            //            MangaPageModView(selectedTab: $selectedTab  )
            
            //            _SettingsView()
            
            //            CropViewPreviews()
            
//            NavigationView{
//                CropContextView(name: "Bakemonogatari_v14w.zip")
//                    .navigationTitle("XXX")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .environmentObject(jobConnectionManager)
//                    .environmentObject(hudMangaer)
//                    .environmentObject(sheetManager)

                //                MangaPageModView( selectedTab: $selectedTab )
                //                    .navigationBarTitle("", displayMode: .inline)

//            }
            //        .environment(\.colorScheme, .dark)
            
            
            
            /// 测试遥控裁剪
//#if targetEnvironment(simulator)
            
//            TestOCR()
            
            
//            NavigationView{
//
//                CropContextView(name: "Bakemonogatari_v14w.zip")
//                    .navigationTitle("XXX")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .environmentObject(jobConnectionManager)
//                    .environmentObject(hudMangaer)
//                    .environmentObject(sheetManager)
//
//            }
            
//#else

//            NewCropViewPreviews()
//            TestOCR()
            
//                CropRemoteControllerView()
//                    .environmentObject(jobConnectionManager)
//                    .environmentObject(hudMangaer)
            
            
//#endif

            
            
            //            CropViewPreviews()
            //            TestCropPreview()
            
            
            
            
            
            //            T()
            
            
            
            //            __contextView()
            
            //            TestNavBarView()
            
            //            MyCollectionView()
            
            //            NewContentView()
            //                .environmentObject(sheetManager)
            
            
            //            MainTabView()
            //                .environmentObject(sheetManager)
            
            //            _SettingsView()
            
            
            //            CatsGalleryView()
            
            //            NavigationView {
            
            
            //            NavigationView{
            //             NewDetailsView( name: "Unsplash" )
            //                .environmentObject(sheetManager)
            //            }
            
        }
        
        
        //            JumpSetcionSideBar(count: 38)
    }
}

