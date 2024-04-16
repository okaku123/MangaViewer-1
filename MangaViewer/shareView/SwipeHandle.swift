//
//  SwipeHandle.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/7/17.
//

import SwiftUI
import SwiftUIPager

enum swipeDirection : Int  , Codable {
    case none
    case up
    case down
    case left
    case right
    case tap1
    case tap2
    case tap3
    case circle
}

struct SwipeHandle: View {
    var body: some View {
        ZStack{
            swipeGesture(callback: {_ in
                
            })
        }
    }
}

struct SwipeHandle_Previews: PreviewProvider {
    static var previews: some View {
        SwipeHandle()
    }
}

struct  swipeGesture : UIViewRepresentable  {
    
    var callback : ( _ : swipeDirection)->()
  
    
    init( callback : @escaping ( _ : swipeDirection)->() ){
        self.callback = callback
    }
    
    func makeCoordinator() -> swipeGesture.Corrdiantor {
        return swipeGesture.Corrdiantor(parent1: self)
    }
    
    
    func makeUIView(context: UIViewRepresentableContext<swipeGesture> ) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        let left = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.left))
        left.direction = .left
        
        let right = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.right))
        right.direction = .right
        
        let up = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.up))
        up.direction = .up
        
        let down = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.down))
        down.direction = .down
        
     
        
        let tap1 = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tap1))
        tap1.numberOfTapsRequired = 1
        
        let tap2 = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tap2))
        tap2.numberOfTapsRequired = 2
        
    
        let tap3 = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tap3))
        tap3.numberOfTapsRequired = 3
        
        tap2.require(toFail: tap3)
        tap1.require(toFail: tap2)
        tap1.require(toFail: tap3)
        
        
       
        
        view.addGestureRecognizer(tap1)
        view.addGestureRecognizer(tap2)
        view.addGestureRecognizer(tap3)
        
        let cgr = XMCircleGestureRecognizer(midPoint: CGPoint(x: UIScreen.main.bounds.width / 2 ,
                                                              y: UIScreen.main.bounds.height / 2 ) ,
                                            target: context.coordinator ,
                                            action: #selector( context.coordinator.rotateGesture))
        
        
        
        view.addGestureRecognizer(left)
        view.addGestureRecognizer(right)
        view.addGestureRecognizer(up)
        view.addGestureRecognizer(down)
        
        
        cgr.delegate = context.coordinator
//        right.delegate = context.coordinator
        
        view.addGestureRecognizer(cgr)
        
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIView , context: UIViewRepresentableContext<swipeGesture>) {
        
    }
    
    class Corrdiantor : NSObject , UIGestureRecognizerDelegate {
        
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            true
        }
        
        
        
        var currentValue:CGFloat = 0.0 {
              didSet {
                  if (currentValue > 100) {
                      currentValue = 0
                      print("circle>>>>")
                      parent.callback(.circle)
                      
                  }
                  if (currentValue < 0) {
                      currentValue = 0
                  }
              }
          }
        
        
        
        var parent : swipeGesture
        
        init( parent1 : swipeGesture ) {
            parent = parent1
        }
        
        
        @objc func left(){
            print("left swipe")
            parent.callback(.left)
        }
        
        @objc func right(){
            print("right swipe")
            parent.callback(.right)
        }
        
        @objc func up(){
            print("up swipe")
            parent.callback(.up)
        }
        @objc func down(){
            print("down swipe")
            parent.callback(.down)
        }
        
        
        @objc func tap1(){
            print("tap ...1")
            parent.callback(.tap1)
        }
        @objc func tap2(){
            print("tap ...2")
            parent.callback(.tap2)
        }
        
        @objc func tap3(){
            print("tap ...3")
            parent.callback(.tap3)
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


