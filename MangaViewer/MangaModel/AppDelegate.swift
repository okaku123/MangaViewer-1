//
//  AppDelegate.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/8/9.
//

import Foundation
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(_serverUrl)
        serverUrl = _serverUrl
        return true
    }
}
