//
//  ShareGroupView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/7/19.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ShareGroupView : View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    @EnvironmentObject var partialSheet: PartialSheetManager
    
    @State var direction : swipeDirection = .none
    @State var currentIndex = 0
    @State var name = ""
    @State var bookNameList = [String]()
    @State var selectedID = "0"
    @State private var selection: String? = nil
    
    @Binding var showMenuBtn : Bool
    
    var colums : [GridItem] {
        if isIpad {
            return [
                GridItem(spacing: 0 ),
                GridItem(spacing: 0 ),
                GridItem(spacing: 0)
            ]
        }else{
            return [
                GridItem(spacing: 0 ),
                GridItem(spacing: 0 )
            ]
        }
    }
    
    
    
    
    var body: some View{
        
        if !bookNameList.contains(name){
            Text("load...")
                .navigationBarTitle( name , displayMode: .inline)
                .onAppear{
                    self.bookNameList.append(name)
                }
        }else{
            
            GeometryReader{ geo in
                
                let count  : CGFloat = isIpad ? 3 : 2
                let space = count + 1
                
                let beforeWidth =  ( geo.size.width - 20 * space ) / count
                let afterWidth = beforeWidth * 0.9
                let beforeHeight =  ( geo.size.width - 20 * space ) / count * 1.3
                let afterHeight = beforeHeight * 0.9
                
                GeometryReader{ geo in
                
                VStack{
                    ScrollViewReader{ reader in
                      
                    ScrollView(.vertical){
                        LazyVGrid(columns: colums, spacing: 20 ) {
                            ForEach( 0 ..< self.bookNameList.count ){ i in
                                let name =  self.bookNameList[i]
                                let url = "\(serverUrl)/getCover/\(name.replacingOccurrences(of: ".zip", with: ".jpg").urlEncoded() )"
                            
                                NavigationLink( destination:
                                                    ShareNewDetailsView(showMenuBtn : $showMenuBtn,
                                                                        name : name)
                                                    .environmentObject( jobConnectionManager )
                                                
                                                , tag : "\(i)" , selection : $selection ){
                                    
                                    VStack{
                                        WebImage(url: URL(string: url ))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: beforeWidth , height: beforeHeight )
                                            .cornerRadius(8)
                                            .clipped()
                                            .background(
                                                VStack{
                                                    if "\(i)" == selectedID {
                                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                            .stroke(lineWidth: 25)
                                                            .foregroundColor(Color.orange)
                                                    }else{
                                                        Spacer()
                                                    }
                                                }
                                            )
                                            .scaleEffect( "\(i)" == selectedID ?  0.9 : 1 )
                                            
                                            .animation(.easeIn(duration: 0.25))
                                        
                                    }
                                    
                                    .onTapGesture {
                                        selectedID = "\(i)"
                                        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                            selectedID = "_"
                                            Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                                self.selection = "\(i)"
                                            }
                                        }
                                    }
                                    
                                }.id("\(i)")
                            }
                        }
                        .frame(width: geo.size.width )
//                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        }
//                    .overlay( swipeGesture{ direction in
//
//                                            if direction == .right {
//                                                currentIndex += 1
//                                                if currentIndex > bookNameList.count - 1 {
//                                                    currentIndex = bookNameList.count - 1
//                                                }
//                                            }
//                                            if direction == .left {
//                                                currentIndex -= 1
//                                                if currentIndex < 0 {
//                                                    currentIndex = 0
//                                                }
//                                            }
//                                            if direction == .down {
//                                                currentIndex += colums.count
//                                                if currentIndex > bookNameList.count - 1 {
//                                                    currentIndex = bookNameList.count - 1
//                                                }
//                                            }
//                                            if direction == .up {
//                                                currentIndex -= colums.count
//                                                if currentIndex < 0 {
//                                                    currentIndex = 0
//                                                }
//                                            }
//
//                                            if direction == .tap1 {
//                                                self.presentationMode.wrappedValue.dismiss()
//                                            }
//
//                                            if direction == .tap2 {
//                                                selection = "\(currentIndex)"
//                                            }
//
//                                                selectedID = "\(currentIndex)"
//
//
//                                            })
                    .onChange(of: direction ){ direction in
                        
                                        if direction == .right {
                                            currentIndex += 1
                                            if currentIndex > bookNameList.count - 1 {
                                                currentIndex = bookNameList.count - 1
                                            }
                                        }
                                        if direction == .left {
                                            currentIndex -= 1
                                            if currentIndex < 0 {
                                                currentIndex = 0
                                            }
                                        }
                                        if direction == .down {
                                            currentIndex += colums.count
                                            if currentIndex > bookNameList.count - 1 {
                                                currentIndex = bookNameList.count - 1
                                            }
                                        }
                                        if direction == .up {
                                            currentIndex -= colums.count
                                            if currentIndex < 0 {
                                                currentIndex = 0
                                            }
                                        }
                        
                                        
                        
                                        DispatchQueue.main.async {
                                            
                                            selectedID = "\(currentIndex)"
                                            withAnimation{
                                                reader.scrollTo("\(currentIndex)", anchor: .center)
                                            }
                                        }
                        
                    
                                        if direction == .tap1 {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                    
                                        if direction == .tap2 {
                                            selection = "\(currentIndex)"
                                        }
                                       
                                        
                                        
                    
                                    }
                    .onAppear{
                        showMenuBtn = false
                        jobConnectionManager.jobReceivedHandler = { msg in
                            print("ShareGroupView->\(msg)")

                            if msg == "left" {
                                self.direction = .none
                                Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                                    self.direction = .left
                                }
                            }else if msg == "right" {
                                self.direction = .none
                                Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                                    self.direction = .right
                                }
                            }else if msg == "up" {
                                self.direction = .none
                                Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                                    self.direction = .up
                                }

                            }else if msg == "down" {
                                self.direction = .none
                                Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                                    self.direction = .down
                                }
                            }
                            else if msg == "tap1"{
                                self.direction = .none
                                Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                                    self.direction = .tap1
                                }
                            }else if msg == "tap2" {
                                self.direction = .none
                                Timer.scheduledTimer(withTimeInterval: 1 / 60 , repeats: false ){_ in
                                    self.direction = .tap2
                                }
                            }
                        }

                    }
                    
                    }
                .navigationBarTitle( name , displayMode: .inline)
            }
                }
        }
    }
    
        }
}

