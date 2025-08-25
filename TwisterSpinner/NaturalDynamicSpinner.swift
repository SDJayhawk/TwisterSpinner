//
//  NaturalDynamicSpinner.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/18/25.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct NaturalDynamicSpinner: View {
    let size: CGSize
    @Binding var spinController: SpinController
    
    // fast base speed (rev/s); change to taste
    //let revsPerSecond: Double = 1 / 0.3  // ~3.33 rev/s

    var body: some View {
        TimelineView(.animation) { context in
            // compute transient angle while spinning (no state mutation here)

            Image("pointer")
                .resizable()
                .scaledToFit()
                .aspectRatio(1, contentMode: .fill)
                .rotationEffect(spinController.rotationEffectDegrees)
                .padding()
        }
    }
}

//#Preview {
//    @Previewable @State var spinController = SpinController()
//    NaturalDynamicSpinner(spinController: $spinController)
//}
