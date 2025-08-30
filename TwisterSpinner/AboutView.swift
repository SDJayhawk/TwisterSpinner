//
//  AboutView.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/23/25.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
                
        VStack(alignment: .center) {
            Text("Twister Spinner")
                .font(.title)
            Text("v\(getVersion())")
        }
        .padding(.bottom)
        VStack(alignment: .leading) {
//            Text("This is **bold** text, this is *italic* text, and this is ***bold, italic*** text.")
//            Text("`Monospaced works too`")
            Text("Use this app as a replacement for the spinner included with your Twister game.")
                .padding(.bottom)
            Text("Instructions")
                .font(.headline)
            Text("Use your finger or other pointing device to spin the spinner then announce the result to the group.")
                .padding(.bottom)
            Text("Select History to see all previous spins. From the history tab, you can use the Clear button to start a new game.")
                .padding(.bottom)
            Text("Feedback")
                .font(.headline)
            Text("Send comments, questions, and feature requests to : [tspinner@srosesoftware.com](mailto:tspinner@srosesoftware.com)")
                .padding(.bottom)
            Spacer()
        }
        .padding()
    }
    
    func getVersion() -> String {
        
//        print("InfoDictionary")
//        Bundle.main.infoDictionary?.forEach { (key: String, value: Any) in
//            print("\(key): \(value)")
//        }
        
        
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
    }
    
}

#Preview {
    AboutView()
}
