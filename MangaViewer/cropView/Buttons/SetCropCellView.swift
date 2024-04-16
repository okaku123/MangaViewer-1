//
//  SetCropCellView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/11.
//

import SwiftUI

struct SetCropCellView : View {
    
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    @Binding var focus : Bool
    @State  var selection: String? = nil
    
    var body: some View {
        
        Section {
            GeometryReader{ geometryProxy in
                NavigationLink( destination: {
                            CropView()
                                .navigationBarTitle("裁剪", displayMode: .inline)
                                        .navigationBarItems(
                                                trailing:
                                                    Button(action: {
//                                                        showPreview.toggle()
                                                    }) {
                                                        Label("设置", systemImage: "greetingcard.fill")
                                                            .foregroundColor(.white)
                                                    }
                                        )
                    
                }()
                                    
                , tag : "SetCropCellView" , selection : $selection ) {
                    
                    HStack {
                        Image(systemName: "aspectratio")
                        VStack(alignment: .leading) {
                            Text("设置页面出血")
                            Text("以当前页面为基准设置整部的出血")
                                .font(.caption)
                                .opacity(0.8)
                               
                        }
                    }
                    .if( selectedTab == title ){ view in
                        view.foregroundColor(.blue)
                    }
                    .onChange(of: focus ){ focus in
                        if focus {
                            selection = "SetCropCellView"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1 / 60 ){
                                self.focus = false 
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        .background(
            ZStack{
            if selectedTab == title {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor , lineWidth: 2 )
                    .padding(.leading, -10)
                    .padding(.trailing, -10)
                    .padding(.top, -3)
                    .padding(.bottom, -3)
                    .opacity(selectedTab == title ? 1 : 0)
                    .matchedGeometryEffect(id: "TAB", in: animation)
            }
        }
        )
        
        
    }
}

