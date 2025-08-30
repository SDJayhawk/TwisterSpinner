//
//  dotCircle.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/19/25.
//


import SwiftUI

struct DotCircle: View {
    let squareFrameSize: Double

    var body: some View {
            let count: Int8 = 16
            let circleSize = squareFrameSize / 6.1
            let radius = (squareFrameSize - circleSize) / 2
            ZStack {
                ForEach(0..<count, id: \.self) { i in
                    let angle = Angle.degrees(
                        Double(i) / Double(count) * 360.0 + 11.25 // Rotate circles for proper positioning with each quadrant
                    )
                    
                    Circle()
                        .fill(LandingColor(rawValue: i%4)?.color ?? .gray) // gray should never happen!
                        .frame(width: circleSize, height: circleSize)
                        .offset(y: -radius)
                        .rotationEffect(angle)
                }
            }
    }
}
