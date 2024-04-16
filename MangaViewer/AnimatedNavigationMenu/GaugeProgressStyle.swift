//
//  GaugeProgressStyle.swift
//  MangaViewer
//
//  Created by okaku on 2024/2/12.
//

import Foundation
import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var color: Color
    var lineWidth: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                // trimでは右が起点なので、反時計回りに90°回転させる
                .rotationEffect(.degrees(-90))
        }
    }
}
