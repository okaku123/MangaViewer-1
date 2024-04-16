//
//  BackgroundController.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/7/26.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation

struct CircleGestureView : UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator( taggle: self.$taggle )
    }
    // Init your ViewController
    
    @Binding var taggle : Bool
    
    func makeUIViewController(context: Context) -> CircleGestureViewController {
        let controller = CircleGestureViewController()
        let cgr = XMCircleGestureRecognizer(midPoint: controller.view.center,
                                            target: context.coordinator ,
                                            action: #selector( context.coordinator.rotateGesture))
        controller.view.addGestureRecognizer(cgr)
        
        return controller
    }
    
    // Tbh no idea what to do here
    func updateUIViewController(_ uiViewController: CircleGestureViewController , context: Context) {

    }
}

extension CircleGestureView {
    
  
   
    class Coordinator: NSObject {
        
        var currentValue:CGFloat = 0.0 {
              didSet {
                  if (currentValue > 100) {
                      taggle = true
                      print(taggle)
                      currentValue = 0
                      Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false){_ in
                          self.taggle = false
                          print(self.taggle)
                      }
                  }
                  if (currentValue < 0) {
                      currentValue = 0
                  }
              }
          }
        
        
        @Binding var taggle : Bool
        init( taggle : Binding<Bool>) {
            _taggle = taggle
        }
        
        
        @objc func rotateGesture(recognizer:XMCircleGestureRecognizer)
         {
             if let rotation = recognizer.rotation {
                 currentValue += rotation.degrees / 360 * 100
//                 print(currentValue)
             }
         }
        
        
    }

}

class CircleGestureViewController : UIViewController{
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        
    }
    
 



    
}
