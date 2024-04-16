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

struct BackgroundController : UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(startBackground: $startBackground)
    }
    // Init your ViewController
    
    @Binding var startBackground : Bool
    
    func makeUIViewController(context: Context) -> BackgroundViewController {
        let controller = BackgroundViewController()
        controller.startBackground = startBackground
        return controller
    }
    
    // Tbh no idea what to do here
    func updateUIViewController(_ uiViewController: BackgroundViewController , context: Context) {

    }
}

extension BackgroundController {
    class Coordinator: NSObject {

        @Binding var startBackground: Bool
        
        init( startBackground : Binding<Bool>) {
            _startBackground = startBackground
        }
     
    }

}

class BackgroundViewController : UIViewController{
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var timer : Timer? = nil
    var count  : Int = 0
    
    
    // 播放音乐保持后台
//    lazy var player: AVQueuePlayer = self.makePlayer()
//
//    private lazy var songs: [AVPlayerItem] = {
//      let songNames = ["FeelinGood", "IronBacon", "WhatYouWant"]
//      return songNames.map {
//        let url = Bundle.main.url(forResource: $0, withExtension: "mp3")!
//        return AVPlayerItem(url: url)
//      }
//    }()
    
   private lazy var player : AVAudioPlayer? = nil
    
    
   @objc func registerBackgroundTask() {
       
       player?.play()
       
       timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { t in
           print("BackgroundTask->\(self.count)s")
           self.count += 1
       })
       
//       print("registerBackgroundTask-->")
//      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
//        self?.endBackgroundTask()
//      }
//      assert(backgroundTask != .invalid)
//       timer = Timer.scheduledTimer(withTimeInterval: 5 , repeats: true){_ in
//           self.count += 1
//           print("keep live...\(self.count)")
//       }
       
    }
      
    @objc func endBackgroundTask() {
        
        player?.pause()
        timer?.invalidate()
        timer = nil
        count = 0
        
        
//      print("Background task ended.")
//        timer?.invalidate()
//        timer = nil
//        count = 0
//      UIApplication.shared.endBackgroundTask(backgroundTask)
//      backgroundTask = .invalid
        
        
    }


    
    var startBackground = false {
        didSet{
            if startBackground {
                registerBackgroundTask()
            }else {
                endBackgroundTask()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("BackgroundViewController - viewDidLoad()")
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(registerBackgroundTask),
                         name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(endBackgroundTask),
                         name: UIApplication.didBecomeActiveNotification, object: nil)
        
        do {
          try AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.playback ,
            mode: .default,
            options: [.mixWithOthers])
            
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
          print("Failed to set audio session category.  Error: \(error)")
        }
        
        if let url = Bundle.main.url(forResource: "FeelinGood", withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url )
            player?.prepareToPlay()
            player?.numberOfLoops = -1
            player?.volume = 0
        }
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(breakAudioSessionEvent),
                         name: AVAudioSession.interruptionNotification, object: nil)
        
        
//
//        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: DispatchQueue.main) { [weak self] time in
//          guard let self = self else { return }
//          let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
//
//          if UIApplication.shared.applicationState == .active {
////            self.timeLabel.text = timeString
//          } else {
//            print("Background: \(timeString)")
//          }
//        }
        
        
    }
    
//    private func makePlayer() -> AVQueuePlayer {
//      let player = AVQueuePlayer(items: songs)
//      player.actionAtItemEnd = .advance
//      player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial] , context: nil)
//      return player
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
////      if keyPath == "currentItem",
////        let player = object as? AVPlayer,
////        let currentItem = player.currentItem?.asset as? AVURLAsset {
////       songLabel.text = currentItem.url.lastPathComponent
////      }
//    }
    
//    @IBAction func playPauseAction(_ sender: UIButton) {
//      sender.isSelected = !sender.isSelected
//      if sender.isSelected {
//        player.play()
//      } else {
//        player.pause()
//      }
//    }
    
    @objc func breakAudioSessionEvent(){
        if let url = Bundle.main.url(forResource: "FeelinGood", withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url )
            player?.prepareToPlay()
            player?.numberOfLoops = -1
            player?.volume = 0
            player?.play()
        }
    }
    
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    
}
