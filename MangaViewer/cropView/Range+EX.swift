//
//  Range+EX.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/14.
//

import Foundation

extension Range where Bound: FixedWidthInteger {

    var random: Bound { .random(in: self) }

    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random } }

}

extension ClosedRange where Bound: FixedWidthInteger  {

    var random: Bound { .random(in: self) }

    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random }

    }

}
