//
//  ShowMeunContext.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/8/14.
//

import Foundation
import SwiftUI

class ShowMeunContext : NSObject, ObservableObject {
    @Published var show : Bool = true
    
    public var timer : Timer? = nil
    public func hideMeun(){
        self.show = false
    }
    public func showMeun(){
        self.show = true
    }
}

