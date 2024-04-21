//
//  ScreenComet.swift
//  MangaViewer
//
//  Created by okaku on 2024/4/16.
//

import Foundation
import SwiftUI
import WebKit
import FileKit

var server: HttpServer?

struct ScreenComet: View {

    @State var showMenu = false
    @State var showMenuBtn = true
    
    @State var url : URL = URL(string: "https://baidu.com")!
    
    let baseUrl = Path.userDocuments.absolute.rawValue
    let screenWidth = UIScreen.main.bounds.width
    let scrennHeight = UIScreen.main.bounds.height
    
    fileprivate func initServer(){
        print(baseUrl)
        server = HttpServer()
        server!["/files/:path"] = directoryBrowser( baseUrl )
        
        server!["/files/Samples/:path"] = directoryBrowser("\(baseUrl)/Samples")
        
        server!["/files/Samples/TypeScript/:path"] = directoryBrowser("\(baseUrl)/Samples/TypeScript")
        
        server!["/files/Samples/TypeScript/Demo/:path"] = directoryBrowser("\(baseUrl)/Samples/TypeScript/Demo")
        
        server!["/files/Samples/TypeScript/Demo/dist/:path"] = directoryBrowser("\(baseUrl)/Samples/TypeScript/Demo/dist")
        
        server!["/files/Samples/Resources/:path"] = directoryBrowser("\(baseUrl)/Samples/Resources")
        
        server!["/files/Samples/Resources/bola_2/:path"] = directoryBrowser("\(baseUrl)/Samples/Resources/bola_2")
        
        server!["/files/Samples/Resources/bola_2/motions/:path"] = directoryBrowser("\(baseUrl)/Samples/Resources/bola_2/motions")
        
        server!["/files/Samples/Resources/bola_2/textures/:path"] = directoryBrowser("\(baseUrl)/Samples/Resources/bola_2/textures")
        
        do {
            try server!.start(8080, forceIPv4: true)
            print("Server has started ( port = \(try server?.port()) ). Try to connect now...")
            if let url = URL(string: "http://localhost:8080/files/Samples/TypeScript/Demo/index.html") {
                self.url = url
            }
        } catch {
            print("Server start error: \(error)")
        }
    }

    var body: some View {
        ZStack{
            Color("blue")
                .ignoresSafeArea()
            
            ZStack{
                
                WebView(url: $url)
                    
//                    .frame(width: showMenu ? screenWidth * 0.6 : screenWidth,
//                           height: showMenu ? scrennHeight * 0.6 : scrennHeight  )
//                    .ignoresSafeArea()
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -250 : 0)
                    .padding(.vertical, 0)
//                    .padding(.vertical , showMenu ? 210 : 0)
                    .onAppear{
                        initServer()
                    }
                
                Color.white
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -50 : 0)
//                    .padding(.vertical , showMenu ? 100 : 0)
                
                Color.white
                    .opacity(0.4)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -150 : 0)
//                    .padding(.vertical , showMenu ? 160 : 0)
                
                


            }
            .scaleEffect(showMenu ? 0.84 : 1)
            .offset(x: showMenu ? getRect().width -  (isIpad ? 700 : 120 ) : 0 )
            .ignoresSafeArea()
            .overlay(
                ZStack(alignment: .center){
                    HStack{
                            AnimateMenuBtn(showMenu: $showMenu)
                        Spacer()
                    }
                    .frame(width : UIScreen.main.bounds.width - 100)
                    .background(Color.white.opacity(0.01))
                }
                .frame(width : UIScreen.main.bounds.width - 100)
                ,
                alignment : .topLeading
                
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

struct ScreenComet_Previews: PreviewProvider {
    static var previews: some View {
        ScreenComet()
    }
}

struct WebView: UIViewRepresentable {
    // 1
    
    @Binding var  url: URL

    
    // 2
    func makeUIView(context: Context) -> WKWebView {

        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView
    }
    
    // 3
    func updateUIView(_ webView: WKWebView, context: Context) {

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    
}
