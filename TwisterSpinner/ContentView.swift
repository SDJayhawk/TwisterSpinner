//
//  ContentView.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/18/25.
//

import SwiftUI

struct ContentView: View {

    @State var spinController = SpinController()

    var body: some View {
        TabView {
            Tab("Spinner", systemImage:
                    "arrow.trianglehead.2.counterclockwise.rotate.90") {
                SpinnerBoardView(spinController: $spinController)
            }
            Tab("History", systemImage: "clock"){
                HistoryView()
            }
            Tab("About", systemImage: "info.circle"){
                AboutView()
            }
        }
    }
}

#Preview {
    ContentView()
}
