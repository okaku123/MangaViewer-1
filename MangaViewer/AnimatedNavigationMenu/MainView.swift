//
//  MainView.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/6/25.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    @EnvironmentObject var hudManager : HUDManager
    @EnvironmentObject var showMeunContext : ShowMeunContext
//    @State var selectedTab = "KeystoreBookManager"
    @State var selectedTab = "WebManager"
    
    @State var showMenu = false
    @State var showMenuBtn = true
    
    @State var HUDOffset : CGFloat = -100
    
    //    @State var showHUD  = false
    
    //    @State var connecting = false
    
    var body: some View {
        ZStack{
            Color("blue")
                .ignoresSafeArea()
            
            ScrollView(getRect().height < 700 ? .vertical : .init() , showsIndicators : false , content : {
                SideMenu(selectedTab: $selectedTab)
            })
            
            ZStack{
                Color.white
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -25 : 0)
                    .padding(.vertical , 30)
                
                Color.white
                    .opacity(0.4)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -50 : 0)
                    .padding(.vertical , 60)
                
                
                
                _Home(selectedtab: $selectedTab , showMenuBtn : $showMenuBtn , showMenu : $showMenu)
                    .cornerRadius(showMenu ? 15 : 0)
                //                    .disabled(showMenu ? true : false)
            }
            .scaleEffect(showMenu ? 0.84 : 1)
            //            .offset(x: showMenu ? getRect().width - 120 : 0 )
            .offset(x: showMenu ? getRect().width -  (isIpad ? 700 : 120 ) : 0 )
            .ignoresSafeArea()
            .overlay(
                ZStack(alignment: .center){
                    HStack{
                        if showMeunContext.show {
                            AnimateMenuBtn(showMenu: $showMenu)
                        }
                        Spacer()
                    }
                    .frame(width : UIScreen.main.bounds.width - 100)
                    .background(Color.white.opacity(0.01))
                    //            .padding(.top, -20)
                    
//                    LottieView(play: $jobConnectionManager.connected , callback: {
//                        //                LottieView(play: $connecting , callback: {
//                        print("..lottie play finish ")
//                    }, loopMode: .loop)
//                    .frame(width: 100 ,height:  50)
//                    .padding(.leading, 100)
                    //                .padding(.top, 5)
                    //                .background(Color.blue)
                    HUD(title: $hudManager.title )
                        .offset(y: HUDOffset )
                        .padding(.leading, 100)
                        .onAnimationCompleted(for: HUDOffset){
                            print("finsih...")
                            let result = hudManager.show
                            hudManager.dismissHandler?( result )
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ){
                                self.hudManager.show = false
                            }
                        }
                        .onChange(of: hudManager.show ){ show in
                            print("change...")
                            withAnimation(.easeInOut){
                                HUDOffset = show ? 0 : -100
                            }
                        }
                }.frame(width : UIScreen.main.bounds.width - 100)
                //            .onAppear{
                //                Timer.scheduledTimer(withTimeInterval: 4, repeats: false){_ in
                //                    showHUD.toggle()
                //                }
                //            }
                
                
                //                VStack{
                //                if showMenuBtn {
                //
                //                Button(action: {
                //                    withAnimation(.spring(), {
                //                        showMenu.toggle()
                //                    })
                //                }, label: {
                //                    VStack( spacing: 5 ){
                //                        Capsule()
                //                            .fill(showMenu ? Color.white : Color.primary)
                //                            .frame(width: 30 , height: 3)
                //                            .rotationEffect(.init(degrees: showMenu ? -50 : 0))
                //                            .offset(x: showMenu ? 2: 0, y: showMenu ? 9 : 0)
                //
                //                        VStack(spacing : 5){
                //                            Capsule()
                //                                .fill(showMenu ? Color.white : Color.primary)
                //                                .frame(width: 30 , height : 3)
                //
                //                            Capsule()
                //                                .fill(showMenu ? Color.white : Color.primary)
                //                                .frame(width: 30 , height: 3)
                //                                .offset( y: showMenu ? -8 : 0)
                //
                //                        }
                //                        .rotationEffect(.init(degrees: showMenu ? 50 : 0))
                //                    }
                //                    .contentShape(Rectangle())
                //
                //                })
                //                .padding()
                //                    }
                //                else{
                //                    Spacer()
                //                }
                //            }
                //                    .background(Color.white.opacity(0.1))
                
                , alignment : .topLeading
                
            )
            .onTapGesture {
                if showMenu {
                    withAnimation(.spring(), {
                        showMenu.toggle()
                    })
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension View {
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
}
