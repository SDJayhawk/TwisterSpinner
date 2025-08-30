//
//  ContentView.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/18/25.
//

import SwiftUI

struct ContentView: View {

    @State var spinController: SpinController

    init() {
        self.spinController = SpinController()
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                SpinnerBoardView(spinController: $spinController)
                    .navigationTitle("Spinner")
            }
            .tabItem {
                Label("Spinner", systemImage:
                        "arrow.trianglehead.2.counterclockwise.rotate.90")
            }
            NavigationStack {
                HistoryView(spinController: $spinController)
                    .navigationTitle("History")
            }
            .tabItem {
                Label("History", systemImage: "clock")
            }
            NavigationStack {
                AboutView()
            }
            .tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
