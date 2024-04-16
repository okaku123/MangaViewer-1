//
//  _ControllView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/12.
//

import Foundation
import SwiftUI
import SwiftUIPager

struct _ControllView: View {
    
    enum Section: String, Identifiable, CaseIterable {
        case all, favorites, recommended
        
        var displayName: String { rawValue.capitalized }
        
        var id: String { self.rawValue }
    }

    @State var total : Int
    @Binding var jumpPageCount : Int
    
    @State  var current: Double = 0
    
    @Binding var page : Page
    
    @Binding var currentIndex : Int
    
    
    @State private var style : MaskStyle = .none
    
    @Binding var segmentedIndex : Int


    var body: some View {
                      VStack(spacing: 8) {
                          GroupBox(label: Label("跳转到", systemImage: "forward.fill")) {
                            HStack{
                                HealthValueView(value: "\(Int(current) + 1 )" , unit: "\(total)" )
                                    .frame(minWidth: 30, idealWidth: 30, maxWidth: 75, minHeight: 18, idealHeight: 18, maxHeight: 18, alignment: .leading)
                                Slider(value: $current , in: 0...Double(total - 1) ){ b in
                                    if !b {
                                        self.jumpPageCount = Int(current)
                                    
                                        page = .withIndex(jumpPageCount)
                                            //跳转操作//
                                        currentIndex = jumpPageCount
                                    }
                                }
                            }
                           
                          }.groupBoxStyle(HealthGroupBoxStyle(color: .blue))
                          .onTapGesture {
                            
                          }
                        
                        HStack( spacing: 8){
                            GroupBox(label: Label("往前5页", systemImage: "")) {
                            }.groupBoxStyle(HealthGroupBoxStyle(color: .blue))
                            .onTapGesture {
                                self.jumpPageCount -= 5
                                if jumpPageCount < 0 {
                                    jumpPageCount = 0
                                }
                                
                                page = .withIndex(jumpPageCount)
                                currentIndex = jumpPageCount
                                current = Double( jumpPageCount )
                                
                            }
                            
                            GroupBox(label: Label("往后5页", systemImage: "")) {
                            }.groupBoxStyle(HealthGroupBoxStyle(color: .blue))
                            .onTapGesture {
                                self.jumpPageCount += 5
                                if jumpPageCount > total {
                                    jumpPageCount = total
                                }
                                
                                page = .withIndex(jumpPageCount)
                                currentIndex = jumpPageCount
                                current = Double( jumpPageCount )
                                
                            }
                        }
                        
                        
                        GroupBox(label: Label("暗幕模式", systemImage: "")) {
                            Segmented(options: ["无暗幕","轻微","加深","深沉"] , selected: $segmentedIndex)
                                
                        }.groupBoxStyle(HealthGroupBoxStyle(color: .blue))
                      
                        
                      
                        
                      }
                 
                      .padding()
//                      .background(Color(.secondarySystemBackground))
                      .edgesIgnoringSafeArea(.bottom)
    
    }
}




