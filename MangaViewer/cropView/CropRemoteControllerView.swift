//
//  CropRemoteControllerView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/12.
//

import SwiftUI

struct CropRemoteControllerView: View {
    
    @EnvironmentObject var hudManager : HUDManager
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    @State var startBackground : Bool = false
    @State var circleTaggle : Bool = false
    @AppStorage("RemoteBGC") var RemoteBGC : String = "0,0,1"
    @State var BGC = Color.blue
    @State private var isModal = false
   
    @State var isOn = false
    
    @State var image : UIImage? = nil
    
    var body: some View {
        NavigationView{
            GeometryReader{  geometryProxy in
            ZStack(alignment: .center ){
                BackgroundController(startBackground: $startBackground )
                    .frame(width: 1, height: 1)
                Form {
                    Section(header:
                                VStack(alignment: .leading){
                                    Text("远程设备")
                                       
                                    if jobConnectionManager.employees.isEmpty {
                                        Divider()
                                        HStack{
                                            Text("点击左下角")
                                            OpenRemoteBtn(isHandle: $jobConnectionManager.isStartBrowsing )
                                                .scaleEffect(0.5)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                            Text("来搜索附近设备")
                                        }
                                        .padding(.top, 4)
                                        
                                    }
                                }
                        
                    
                    , footer:
                                VStack(alignment: .leading , spacing: 5){
                                 Divider()
                                    HStack{
                                        Image(systemName: "bolt.horizontal")
                                            .font(.body)
                                        Text("将显示附近的远程设备，点击来连接")
                                    }
                                    HStack{
                                        Image(systemName: "hand.draw")
                                            .font(.body)
                                        Text("使用手势来控制远程设备")
                                    }
                                    HStack{
                                        Image(systemName: "arrow.up.circle")
                                            .font(.body)
                                        Text("用上/下滑动手势来移动光标")
                                    }
                                    HStack{
                                        Image(systemName: "arrow.right.circle")
                                            .font(.body)
                                        Text("用左/右滑动手势来增/减 控制量")
                                    }
                                    HStack{
                                        Image(systemName: "hand.tap")
                                            .font(.body)
                                        Text("点击一次用于确定项目")
                                    }
                                    HStack{
                                        Image(systemName: "hand.tap")
                                            .font(.body)
                                        Text("点击两次用于退出某些项目")
                                    }
                                    HStack{
                                        Image(systemName: "goforward")
                                            .font(.body)
                                        Text("圆圈手势用于开启选单")
                                    }
                                    HStack{
                                        Image(systemName: "arrow.turn.up.forward.iphone")
                                            .font(.body)
                                        Text("某些操作会移动到遥控设备进行")
                                    }
                                }
                            ) {
                        List{
                            
                            ForEach(jobConnectionManager.employees ,id: \.self ){ item in
                                HStack {
                                  VStack(alignment: .leading) {
                                    Text( item.displayName )
                                      .font(.title3)
                                      .foregroundColor(Color.blue)
                                  }
                                  Spacer()
                                }
                                .onTapGesture {
                                    if !jobConnectionManager.employees.isEmpty {
                                        jobConnectionManager.invitePeer(jobConnectionManager.employees.first! , to : "...")
                                            }
                                    }
                            }
                        }
                    }
                }
                
                
                GeometryReader{ geo in
                ZStack{
                    Ring(width: UIScreen.main.bounds.width / 2 , isOn: $isOn)
                        .offset(y: 70)
                    Ring(width: UIScreen.main.bounds.width / 1.6  , isOn: $isOn)
                        .offset(y: 80)
                    Ring(width: UIScreen.main.bounds.width / 1.3 , isOn: $isOn)
                        .offset(y: 90)
                    Ring(width: UIScreen.main.bounds.width / 1.1, isOn: $isOn)
                        .offset(y: 100)
                    Ring(width: UIScreen.main.bounds.width , isOn: $isOn)
                        .offset(y: 100)
                }
                .padding(.top ,  geo.size.height - geo.size.width )
            }

                
                VStack{
                    Spacer()
                    HStack{
                        //MARK:  -
                        //MARK: 负责开启或关闭接受远程设备的广播 -
                        OpenRemoteBtn(isHandle: $jobConnectionManager.isStartBrowsing ){
                            /// 关闭的时候移除所有peer
                            if jobConnectionManager.isStartBrowsing == false {
                                jobConnectionManager.employees.removeAll()
                            }
                            
                            ///单元测试 暂时无法测试出效果
//                            hudManager.icon = jobConnectionManager.isStartBrowsing ? "bolt.horizontal.fill" : "bolt.horizontal"
//                            hudManager.title =  jobConnectionManager.isStartBrowsing ? "接受就绪" : "接受关闭"
//                            hudManager.show.toggle()
                            
                        }
                        .padding()
                        
                        Spacer()
                        CropButton{
                            isModal.toggle()
                        }
                        .padding()
                    }.padding()
                }
                
       
            }
            .background(BGC)
            .frame(width: geometryProxy.size.width , height: geometryProxy.size.height )
                
            }
//            .padding(.top, 33)
            .if(jobConnectionManager.connected){
                $0.overlay(

                    
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
                
                )
            }
            .onAppear{
                jobConnectionManager.jobReceivedHandler = { msg in
                    print(msg)
                }
                
                jobConnectionManager.dataReceivedHandler = { data in
                    ///检查传输的数据类型
                    
                    print(data)
                    guard data.count > 30 else { return }
                    let typeData = data.subdata(in: 0..<30 )
                    guard let type = String(data: typeData, encoding: .utf8) else { return }
                    print("type: \(type)")
                    
                    if type.contains( "crop://") {
                        let count = data.count
                        let imageData = data.subdata(in: 30..<count )
                        guard  let image = UIImage(data: imageData ) else { return }
                        print(image)
                        print(image.cgImage?.width)
                        
                        self.image = image
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                            isModal.toggle()
                        }
                        
                        
                    }
                }
                
            }
            .navigationBarTitle("遥控器", displayMode: .inline)
        }
        .sheet(isPresented: $isModal, content: {
            NewCropViewPreviews(image: $image )
        })
        
    }
}

struct CropRemoteControllerView_Previews: PreviewProvider {
    static var previews: some View {
        CropRemoteControllerView()
    }
}
