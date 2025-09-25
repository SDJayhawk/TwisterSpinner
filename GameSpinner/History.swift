//
//  History.swift
//  GameSpinner
//
//  Created by Steve Rose on 8/25/25.
//

import Foundation
import SwiftUI

class History {
    
    private var items: [SpinResult] = []
    
    func add(_ item: SpinResult) {
        items.append(item)
    }
    
    func getItems() -> [SpinResult] {
        return items
    }
    
    func clear() {
        print("items.removeAll()")
        items.removeAll()
    }
}

struct SpinResult: Hashable {
    let index = UUID()
    let appendage: Appendage
    let landingColor: LandingColor    
}
