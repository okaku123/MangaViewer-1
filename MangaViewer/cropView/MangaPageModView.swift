//
//  MangaPageModView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/10.
//

import SwiftUI
import Nuke

struct MangaPageModView: View {
    
    /// 近距离通信
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var cropPageOffset = 0
    @State var cropPage = false
    @State var date = Date()
    @State var selection = 0
    @State var focusList = [ false , false , false , false ]
    
    @State var selectedTab : String
    @State static var cropPageOffset = 0
    @State var cropImageUrl  = ""
    @Namespace var animation
    
    
    
    @State var jumpPageIndex = 0
    @State var jumpCount : Int = 0
    
    var body: some View {
        GeometryReader{ proxy in
                Form {
                   
                    Section{
                    
                    LastReadButton(title: "0",
                                   selectedTab : $selectedTab ,
                                   animation : animation )
                    
                    PageJumpButton(title: "1", selectedTab: $selectedTab, animation: animation, jumpCount: $jumpCount )
                        
                    }
                    
                    CloseSheetButton(title: "2", selectedTab: $selectedTab , animation: animation )
                    
                    Section{
                    
                    OpenCropFuncCellView(title: "3",
                                            selectedTab : $selectedTab ,
                                            animation : animation ,
                                            focus: $focusList[0] )
                    
                    SetCropCellView(title: "4",
                                    selectedTab: $selectedTab ,
                                    animation: animation,
                                    focus: $focusList[2] )
                    }
                }
                .onAppear{
                    jobConnectionManager.jobReceivedHandler = { msg in
                        if msg == "right" {
                            if selectedTab == "1" {
                                cropPageOffset += 1
                                cropPageOffset > 9 ? ( cropPageOffset = 9  ) : ()
                            }
                        }else if msg == "left" {
                            if selectedTab == "1" {
                                cropPageOffset -= 1
                                cropPageOffset < 0 ? (cropPageOffset = 0) : ()
                            }
                            
                        }else if msg == "down" {
                            var tmp = selection
                            tmp += 1
                            if tmp > 3{
                                tmp = 3
                            }
                            selection = tmp
                            
                            withAnimation(.spring()){
                                selectedTab = "\(tmp)"
                            }
                            
                        }else if msg == "up" {
                            var tmp = selection
                            tmp -= 1
                            if tmp < 0{
                                tmp = 0
                            }
                            selection = tmp
                            withAnimation(.spring()){
                                selectedTab = "\(tmp)"
                            }
                            
                        }else if msg == "tap1"{
                            
                            ///这里修改为传输整个uiimage 数据 避免遥控器不在一个局域网的情况
                            if selection == 2 {
                              guard let url = URL(string: cropImageUrl) else {
                                        return
                                    }
                                let request = ImageRequest(url: url )
                                ImagePipeline.shared.loadData(with: request){ result in
                                    guard let _result = try? result.get() ,
                                          let peer = jobConnectionManager.connectedPeers.first else { return }
                                   
                                    let type = "crop://"
                                    guard var typeData = type.data(using: .utf8) else {return}
                                    let tmpData = Data( count : ( 30 - typeData.count ) )
                                    typeData.append(tmpData)
                                    print("typeData.count:\(typeData.count)")
                                    let data = _result.data
                                    typeData.append(data)
                                    jobConnectionManager.send( typeData , to: peer)
                                    print("jobConnectionManager.send")
                                    }
                                return
                            }
                            
                            //通常状态
                            focusList[selection]  = !focusList[selection]
                            
                        }else if msg == "tap2"{
                            
                        }
                        
                    }
                }
            
        }
        
    }}



//                .overlay(
//
//                    swipeGesture{ direction in
//                    if direction == .right {
//
//                        if selectedTab == "1" {
//                            cropPageOffset += 1
//                            cropPageOffset > 9 ? ( cropPageOffset = 9  ) : ()
//                        }
//                    }
//                    if direction == .left {
//
//                        if selectedTab == "1" {
//                            cropPageOffset -= 1
//                            cropPageOffset < 0 ? (cropPageOffset = 0) : ()
//                        }
//                    }
//                    if direction == .down {
//                        var tmp = selection
//                        tmp += 1
//                        if tmp > 3{
//                            tmp = 3
//                        }
//                        selection = tmp
//
//                        withAnimation(.spring()){
//                            selectedTab = "\(tmp)"
//                        }
//                    }
//                    if direction == .up{
//                        var tmp = selection
//                        tmp -= 1
//                        if tmp < 0{
//                            tmp = 0
//                        }
//                        selection = tmp
//                        withAnimation(.spring()){
//                            selectedTab = "\(tmp)"
//                        }
//                    }
//
//                    if direction == .tap2 {
//
//                    }
//
//                    if direction == .tap1 {
//                        focusList[selection]  = !focusList[selection]
//
//                    }
//
//                    if direction == .tap3 {
//
//                    }
//
//                    if direction == .circle {
//
//                    }
//                })

