//
//  Data+.swift
//  MangaViewer
//
//  Created by okaku on 2024/3/30.
//

import Foundation

extension Data {
    func toUInt16LE() -> UInt16 {
        var value: UInt16 = 0
        (self as NSData).getBytes(&value, length: MemoryLayout<UInt16>.size)
        return UInt16(littleEndian: value)
    }

    func toUInt32LE() -> UInt32 {
        var value: UInt32 = 0
        (self as NSData).getBytes(&value, length: MemoryLayout<UInt32>.size)
        return UInt32(littleEndian: value)
    }
    
    func toUInt8Array() -> [UInt8] {
        return [UInt8](self)
    }
}




