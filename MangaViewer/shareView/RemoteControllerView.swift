//
//  RemoteControllerView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/7/22.
//

import SwiftUI
import MultipeerConnectivity

struct RemoteControllerView: View {
    
    
    @Binding var selectedTab : String
    @EnvironmentObject var hudManager : HUDManager
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    @State var startBackground : Bool = false
    @AppStorage("RemoteBGC") var RemoteBGC : String = "0,0,1"
    @State var BGC = Color( UIColor(hexString: "#475569") )
    
    @State var circleTaggle : Bool = false
    
    
    
    @State var pageCount: Int = 0
    @State var pageCountStr: String = ""
    @State var keyboardHeight : CGFloat = 0
    
    
    func findPageCount(){
        jobConnectionManager.send( "pageCount" )
    }
    
    //处理连续互通传来的msg，设置pageCount
    func setPageCount(with msg: String){
        if msg.contains("pageCount:"){
            let countStr = msg.replacingOccurrences(of: "pageCount:", with: "")
            if let count = Int( countStr ) {
                pageCount = count
            }
        }
    }
    
    func jumpPageCount(){
        if let count = Int( pageCountStr ) , count < pageCount {
            jobConnectionManager.send( "jump:\(count)" )
            hudManager.title = "跳转页面"
            hudManager.show.toggle()
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                BackgroundController(startBackground: $startBackground )
                    .frame(width: 1, height: 1)
                    .hidden()
                
                    VStack(alignment: .center ){
                        
                        ForEach(jobConnectionManager.employees ,id: \.self ){ item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text( item.displayName )
                                        .font(.title3)
                                        .foregroundColor(Color.blue)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(RoundedCorners(color: .white , tl: 8, tr: 8, bl: 8, br: 8))
                            .onTapGesture {
                                if !jobConnectionManager.employees.isEmpty {
                                    jobConnectionManager.invitePeer(jobConnectionManager.employees.first! , to : "...")
                                }
                            }
                            
                        }
                    }.padding()
                Spacer()
            }
            .frame( width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height - UIApplication.shared.windows.first!.safeAreaInsets.bottom
                )
            .background(BGC)
//            .padding(.top, 33)
            .if(jobConnectionManager.connected){
//            .if( true ){
                $0.overlay(
                    VStack{
                        swipeGesture{ direction in
                            
                            if direction == .right {
                                jobConnectionManager.send( "right" )
                            }
                            if direction == .left {
                                jobConnectionManager.send( "left" )
                            }
                            if direction == .down {
                                jobConnectionManager.send( "down" )
                            }
                            if direction == .up{
                                jobConnectionManager.send( "up" )
                            }
                            
                            if direction == .tap2 {
                                jobConnectionManager.send( "tap2" )
                            }
                            
                            if direction == .tap1 {
                                jobConnectionManager.send( "tap1" )
                            }
                            
                            if direction == .tap3 {
                                jobConnectionManager.send( "tap3" )
                            }
                            
                            if direction == .circle {
                                jobConnectionManager.send("circle")
                            }
                        }
                        .frame( width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height -
                                UIApplication.shared.windows.first!.safeAreaInsets.top - UIApplication.shared.windows.first!.safeAreaInsets.bottom -
                                80
                        ).onAppear{
                            if selectedTab == "控制器" {
                                jobConnectionManager.jobReceivedHandler = { msg in
                                    setPageCount( with: msg)
                                   
                                    
                                }
                            }
                        }
                        
                        HStack(alignment: .bottom ){
                            
                            Button(action: {
                                findPageCount()
                            }) {
                                Label("总页面\(pageCount)", systemImage: "")
                                    .foregroundColor(Color.blue)
                            }
                            
                            TextField("请输入跳转页数", text: $pageCountStr )
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                            
                            Button(action: {
                                jumpPageCount()
                            }) {
                                Label("跳转", systemImage: "")
                                    .foregroundColor(Color.blue)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(18)
                        .frame( width: UIScreen.main.bounds.width - 16,  height: 60 )
                        
                        .offset(y: -keyboardHeight )
                        .animation( .spring() )
                        
                      
                    }.frame( width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height - UIApplication.shared.windows.first!.safeAreaInsets.bottom
                        )
                        .dismissKeyboardOnTap()
                    
                )
                
            }
            .onAppear{
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.current) { (noti) in
                          let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                              let height = value.height
                           self.keyboardHeight = height - UIApplication.shared.windows.first!.safeAreaInsets.bottom

                        }
                        //键盘收起
                     NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.current) { (noti) in
                                self.keyboardHeight = 0
                        }
            }
            .navigationBarItems(
                trailing:
                    Button(action: {
                        hudManager.title = "遥控器就绪"
                        hudManager.dismissHandler = { show in
                            if show {
                                return
                            }
                            print("come from remote ...")
                        }
                        hudManager.show.toggle()
                        
                        print("btn press...")
                        if !jobConnectionManager.isStartBrowsing{
                            jobConnectionManager.isStartBrowsing = true
                        }
                    }) {
                        Label("控制\(pageCount)", systemImage: "dial.min.fill")
                            .foregroundColor(Color.white)
                    }
            )
            .navigationBarTitle("遥控器", displayMode: .inline)
            .foregroundColor(.black)
        }
        
    }
}


struct ControllCardView: View {
    
    @Binding var pageCount: Int
    @Binding var currentPageCount: Int
    @State var jumpCount: String = "0"

    var body: some View{
        
        VStack( spacing: 10){
            Text( "跳转指定页面" ).font(.system(size: 18)).bold()
            Form {
                TextField("0", text: $jumpCount )
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
        }
        .background(Color.white)
        .dismissKeyboardOnTap()
    }
    
}

