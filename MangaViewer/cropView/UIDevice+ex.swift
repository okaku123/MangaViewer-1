//
//  UIDevice+ex.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/12.
//

import Foundation
import UIKit

///似乎不是很用...
extension UIDevice {
   open var isSimulator: Bool {
        #if IOS_SIMULATOR
            return true
        #else
            return false
        #endif
    }
}
