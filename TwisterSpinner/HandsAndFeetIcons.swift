//
//  HandsAndFeetIcons.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/21/25.
//


import SwiftUI

struct HandsAndFeetIcons: View {
    let side: Double

    var body: some View {
            Grid {
                GridRow {
                    IconView(imageName: "foot.left", size: side/6, yOffset: -side/3, anchor: .topLeading)
                    Spacer()
                    IconView(imageName: "hand.right", size: side/6, yOffset: -side/3, anchor: .topTrailing)
                }
                
                GridRow {
                    IconView(imageName: "hand.left", size: side/6, yOffset: side/3, anchor: .bottomLeading)
                    Spacer()
                    IconView(imageName: "foot.right", size: side/6, yOffset: side/3, anchor: .bottomTrailing)
                }
            }
    }
}

struct IconView: View {
    let imageName: String
    let size: CGFloat
    let yOffset: CGFloat
    let anchor: UnitPoint
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: size, height: size)
            .gridCellAnchor(anchor) // Align to top-leading corner
            .offset(x: 0, y: yOffset)
    }
}
