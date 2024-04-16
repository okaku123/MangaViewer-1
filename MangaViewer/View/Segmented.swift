//
//  Segmented.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/12.
//

import Foundation
import UIKit
import SwiftUI

let fullScreenSize = UIScreen.main.bounds.size

struct  Segmented : UIViewRepresentable {
    
    
    @State var options = [String]()
    @Binding var selected : Int
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let segmente = UISegmentedControl( items: options )
        segmente.selectedSegmentIndex = selected
        segmente.frame.size = CGSize( width: fullScreenSize.width * 0.8, height: 30)
        let coordinator = context.coordinator as SegmentedCoordinator
        segmente.addTarget( coordinator , action: #selector( coordinator.valueChanged(_:) ), for: .valueChanged)
        return segmente
    }
    
    func makeCoordinator() ->SegmentedCoordinator  {
        SegmentedCoordinator( self )
    }
    
}

class SegmentedCoordinator : NSObject  {
    
    var this  : Segmented
    
     init( _ this : Segmented) {
        self.this = this
    }
    
    @objc func valueChanged(_ sender : UISegmentedControl){
        print(sender.selectedSegmentIndex)
        this.selected = sender.selectedSegmentIndex
 }
    
}


struct Segmented_Previews: PreviewProvider {
    

    static var previews: some View {
        Spacer()
//        Segmented(options: ["1","2","3"])
    }
    
}
