//
//  LottieView.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/8/12.
//

import SwiftUI
import Lottie
import UIKit

struct LottieView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    
    @Binding var play : Bool
    
    var callback : (()->())?
    var loopMode : LottieLoopMode = .playOnce
   
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView{
    let view = UIView(frame: .zero) // Empty View
    let animationView = AnimationView() // Empty animation
    let animation = Animation.named("6778-siri-style-loading") //Import Lottie Animation
    animationView.animation = animation // Set the Animation to the View
    animationView.contentMode = .scaleAspectFill // Scale it
        animationView.loopMode = .loop
//    animationView.play() // Play !
    //SET THE CONST !
    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)
    NSLayoutConstraint.activate([
    animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
    animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
        var animationView : AnimationView!
        for sub in uiView.subviews{
            if sub.isKind(of: AnimationView.self){
                animationView = sub as? AnimationView
                break
            }
        }
        
        if play {
            animationView.play{_ in
                callback?()
            }
        }else{
            animationView.pause()
        }
        
        
    }
    
}

struct LottiePreviews : View{
    
    @State var play = false
    @State private var color = Color.red
    
    var body: some View{
        VStack(spacing : 20 ){
           
            ColorPicker("color", selection: $color, supportsOpacity: true)
                .padding()
            LottieView(play: $play, callback: {
                print("..lottie play finish ")
            }, loopMode: .loop)
//            .frame(width:UIScreen.main.bounds.width , height: UIScreen.main.bounds.width)
            .frame(width: 200, height: 200)
            .padding()
            
            Toggle("play or pause", isOn: $play)
                .padding()
        }
    }
    
    
}


struct LottieView_Previews: PreviewProvider {
    
    static var previews: some View {
            LottiePreviews()
       
    }
}
