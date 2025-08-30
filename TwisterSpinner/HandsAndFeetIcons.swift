//
//  HandsAndFeetIcons.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/21/25.
//


import SwiftUI

struct HandsAndFeetIcons: View {
    let side: Double
    let sizeAdjustment: Double
    let offsetAdjustment: Double
    
    let sizeAdjustmentFactor = 9.0
    let offsetAdjustmentFactor = 3.0

    init(side: Double) {
        self.side = side
        sizeAdjustment = side/sizeAdjustmentFactor
        offsetAdjustment = side/offsetAdjustmentFactor
    }
    
    var body: some View {
            Grid {
                GridRow {
                    LabelAboveIconView(label: Appendage.leftFoot.displayName, imageName: Appendage.leftFoot.getImageName, size: sizeAdjustment, yOffset: -offsetAdjustment, anchor: .topLeading)
                    Spacer()
                    LabelAboveIconView(label: Appendage.rightHand.displayName, imageName: Appendage.rightHand.getImageName, size: sizeAdjustment, yOffset: -offsetAdjustment, anchor: .topTrailing)
                }
                
                GridRow {
                    LabelBelowIconView(label: Appendage.leftHand.displayName, imageName: Appendage.leftHand.getImageName, size: sizeAdjustment, yOffset: offsetAdjustment, anchor: .bottomLeading)
                    Spacer()
                    LabelBelowIconView(label: Appendage.rightFoot.displayName, imageName: Appendage.rightFoot.getImageName, size: sizeAdjustment, yOffset: offsetAdjustment, anchor: .bottomTrailing)
                }
            }
    }
}

struct LabelAboveIconView: View {
    let label: String
    let imageName: String
    let size: CGFloat
    let yOffset: CGFloat
    let anchor: UnitPoint
    
    var body: some View {
        VStack {
            Text(label)
                .font(.headline)

            Image(imageName)
                .resizable()
                .frame(width: size, height: size)
                .gridCellAnchor(anchor) // Align to top-leading corner
        }
        .offset(x: 0, y: yOffset)
    }
}

struct LabelBelowIconView: View {
    let label: String
    let imageName: String
    let size: CGFloat
    let yOffset: CGFloat
    let anchor: UnitPoint
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: size, height: size)
                .gridCellAnchor(anchor) // Align to top-leading corner
            Text(label)
        }
        .offset(x: 0, y: yOffset)
    }
}
