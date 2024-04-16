//
//  Global.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/29.
//

import Foundation
import SwiftUI

//@AppStorage("serverUrl") var serverUrl: String = "http://192.168.1.3:3001"

var serverUrl = "http://192.168.1.102:3001"

var _serverUrl : String {
    get {
        UserDefaults.standard.string(forKey: "serverUrl") ?? "http://192.168.1.102:3001"
        }
    set {
        UserDefaults.standard.set(newValue, forKey: "serverUrl")
    }
}

