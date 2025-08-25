//
//  dotCircle.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/19/25.
//


import SwiftUI

struct DotCircle: View {
    let side: Double

    var body: some View {
            let count: Int8 = 16
            let dotSize = side / 6.1
            let radius = (side - dotSize) / 2
            ZStack {
                ForEach(0..<count, id: \.self) { i in
                    let angle = Angle.degrees(
                        Double(i) / Double(count) * 360.0 + 10.25
                    )
                    
                    Circle()
                        .fill(getColor(i%4)?.color ?? .gray)
                        .frame(width: dotSize, height: dotSize)
                        .offset(y: -radius)
                        .rotationEffect(angle)
                }
            }
    }
    
    func getColor(_ i: Int8) -> LandingColor? {
        return LandingColor(rawValue: i)
    }
}
