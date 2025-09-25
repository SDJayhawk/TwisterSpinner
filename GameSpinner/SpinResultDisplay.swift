//
//  SpinResultDisplay.swift
//  GameSpinner
//
//  Created by Steve Rose on 8/25/25.
//


import SwiftUI

struct SpinResultDisplay: View {
    let spinResult: SpinResult
    var body: some View {
        HStack {
            AppendageInCircle(spinResult:spinResult)
            Spacer()
            Text("\(spinResult.appendage.displayName) on \(spinResult.landingColor.color.description.capitalized)")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct AppendageInCircle: View {
    let spinResult: SpinResult
    var body: some View {
        ZStack {
            Circle().fill(spinResult.landingColor.color)
                .frame(height: 45)
            Image(spinResult.appendage.getImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 25)
        }
    }
}
