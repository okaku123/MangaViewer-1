

import Foundation
import MultipeerConnectivity
import SwiftUI

class JobConnectionManager : NSObject , ObservableObject {
  typealias JobReceivedHandler = (String) -> Void
  typealias DataReceivedHandler = (Data) -> Void
    
  @AppStorage("serverUrl") var _serverUrl = "http://192.168.1.3:3001"
    
  private static let service = "jobmanager-jobs"

  @Published var employees : [MCPeerID] = []
  @Published var connectedPeers : [MCPeerID] = []
    
  @Published var connected: Bool = false

  private var session: MCSession
  private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
  private var nearbyServiceBrowser: MCNearbyServiceBrowser
  private var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
  var jobReceivedHandler: JobReceivedHandler?
  var dataReceivedHandler : DataReceivedHandler? = nil

//  private var jobToSend: JobModel?
    
  private var peerInvitee: MCPeerID?
    

  init(  _  jobReceivedHandler:  JobReceivedHandler? = nil) {
    session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
    nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(
      peer: myPeerId,
      discoveryInfo: nil,
      serviceType: JobConnectionManager.service)
    nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: JobConnectionManager.service)
    self.jobReceivedHandler = jobReceivedHandler
    super.init()
    session.delegate = self
    nearbyServiceAdvertiser.delegate = self
    nearbyServiceBrowser.delegate = self
  }

  func startBrowsing() {
    nearbyServiceBrowser.startBrowsingForPeers()
  }

  func stopBrowsing() {
    nearbyServiceBrowser.stopBrowsingForPeers()
  }

  var isReceivingJobs: Bool = false {
    didSet {
      if isReceivingJobs {
        nearbyServiceAdvertiser.startAdvertisingPeer()
          print("nearbyServiceAdvertiser.startAdvertisingPeer()")
      } else {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
      }
    }
  }
    
    
    var isStartBrowsing: Bool = false {
      didSet {
        if isStartBrowsing {
            startBrowsing()
        } else {
            stopBrowsing()
        }
      }
    }

  func invitePeer(_ peerID: MCPeerID, to job: String ) {
      guard let context = job.data(using: .utf8) else {return}
      nearbyServiceBrowser.invitePeer(peerID, to: session, withContext: context, timeout: TimeInterval(120))
  }

//  private func send(_ job: JobModel, to peer: MCPeerID) {
//    do {
//      let data = try JSONEncoder().encode(job)
//      try session.send(data, toPeers: [peer], with: .reliable)
//    } catch {
//      print(error.localizedDescription)
//    }
//  }
//}
    
    
    ///直接发送data数据 传输较大数据
    func send(_ data: Data , to peer: MCPeerID ) {
      do {
        try session.send(data, toPeers: [peer], with: .reliable)
      } catch {
        print(error.localizedDescription)
      }
    }
    
    
    func send(_ job: String, to peer: MCPeerID ) {
      do {
//        let data = try JSONEncoder().encode(job)
          
          guard let data =  job.data(using: .utf8) else {
              return
          }
        
          
        try session.send(data, toPeers: [peer], with: .reliable) 
      } catch {
        print(error.localizedDescription)
      }
    }
    
    
    func send(_ job: String ) {
      do {
        print("employees->\(employees)")
        guard let data =  job.data(using: .utf8)  , let peer = employees.first else {
              return
          }
          try session.send( data , toPeers: [ peer ] , with: .reliable)
      } catch {
        print(error.localizedDescription)
      }
    }
    
    func send( with swipe : swipeDirection ) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: swipe , requiringSecureCoding: true)
            else { fatalError("can't encode anchor") }
      do {
          try session.send( data , toPeers: connectedPeers , with: .reliable)
      } catch {
        print(error.localizedDescription)
      }
    }
    
    
    
    
    
  }

extension JobConnectionManager: MCNearbyServiceAdvertiserDelegate {
    
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    guard
      let window = UIApplication.shared.windows.first,
      let context = context,
      let jobName = String(data: context, encoding: .utf8)
    else { return }
      
      ///暂时不弹框
      invitationHandler(true, self.session)

    let title = "Accept \(peerID.displayName)'s Job"
    let message = "Would you like to accept: \(jobName)"
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    alertController.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
      invitationHandler(true, self.session)
    })
      DispatchQueue.main.async {
          window.rootViewController?.present(alertController, animated: true)
      }
    
      
  }
}

extension JobConnectionManager: MCNearbyServiceBrowserDelegate {
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
    if !employees.contains(peerID) {
      employees.append(peerID)
    }
  }

  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    guard let index = employees.firstIndex(of: peerID) else { return }
    employees.remove(at: index)
      print("lostPeer...")
  }
    
}

extension JobConnectionManager: MCSessionDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case .connected:
        print("connected")
//        print(employees)
        DispatchQueue.main.async {
            self.connected = true
            if !self.connectedPeers.contains(peerID) {
                self.connectedPeers.append(peerID)
            }
        }
    case .notConnected:
        DispatchQueue.main.async {
            self.connected = false
            guard let index = self.connectedPeers.firstIndex(of: peerID) else { return }
            self.connectedPeers.remove(at: index)
        }

      print("--Not connected: \(peerID.displayName)")
    case .connecting:
      print("Connecting to: \(peerID.displayName)")
    @unknown default:
      print("Unknown state: \(state)")
    }
  }

  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
      
      ///判断是不是大数据传输
      if data.count > 100 {
          DispatchQueue.main.async {
              print("go right")
                 self.dataReceivedHandler?(data)
          }
          return
      }
      
      
      
      
      ///短小的字符串传输
      guard let msg = String(data: data, encoding: .utf8) else {
          return
      }
//      print(msg)
 
      if msg.contains("crop://"){
          DispatchQueue.main.async {
                 self.jobReceivedHandler?(msg)
          }
          return
      }
      
      
      if msg.contains("http://"){
          DispatchQueue.main.async {
              serverUrl = msg
              self._serverUrl = msg
          }
      }
      
     DispatchQueue.main.async {
            self.jobReceivedHandler?(msg)
     }
      

      
      
//    guard let job = try? JSONDecoder().decode(JobModel.self, from: data) else { return }
//    DispatchQueue.main.async {
//      self.jobReceivedHandler?(job)
//    }
  }

  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
