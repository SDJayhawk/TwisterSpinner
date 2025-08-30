//
//  NaturalDynamicSpinner.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/18/25.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct NaturalDynamicSpinner: View {
    @Binding var spinController: SpinController

    var body: some View {
        TimelineView(.animation) { context in
            // compute transient angle while spinning (no state mutation here)

            Image("pointer")
                .resizable()
                .scaledToFit()
                .rotationEffect(spinController.rotationEffectDegrees)
                .padding()
        }
    }
}
