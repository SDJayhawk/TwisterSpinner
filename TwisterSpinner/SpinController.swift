//
//  swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/19/25.
//

import Foundation
import SwiftUI

enum Appendage {
    case leftHand
    case rightHand
    case leftFoot
    case rightFoot
    
    var getImageName:String {
        return switch self {
            case .leftHand:
                "hand.left"
            case .rightHand:
                "hand.right"
            case .leftFoot:
                "foot.left"
            case .rightFoot:
                "foot.right"
        }
    }

    var displayName: String {
        return switch self {
            case .leftHand:
                "Left Hand"
            case .rightHand:
                "Right Hand"
            case .leftFoot:
                "Left Foot"
            case .rightFoot:
                "Right Foot"
        }
    }

}

enum LandingColor: Int8, CaseIterable {
    case green = 0
    case red = 1
    case yellow = 2
    case blue = 3
    
    var color: Color {
        return switch self {
            case .green:
                Color.green
            case .red:
                Color.red
            case .yellow:
                Color.yellow
            case .blue:
                Color.blue
        }
    }
}

@Observable class SpinController {
    var spinning = false
    var clockwise = true
    var baseAngle: Double = 90
    var spinStartTime: Date? = nil
    var stopWorkItem: DispatchWorkItem?
    
    let revsPerSecond: Double = 1 / 0.3  // ~3.33 rev/s

    var dynAngle: Double {
        guard let start = spinStartTime?.timeIntervalSinceReferenceDate
        else { return 0 }
        
        let elapsed = Date().timeIntervalSinceReferenceDate - start
        return ((clockwise ? 1 : -1) * elapsed * revsPerSecond * 360).truncatingRemainder(
            dividingBy: 360
        )
    }

    var rotationEffectDegrees: Angle {
        .degrees(baseAngle + dynAngle)
    }
    
    func startSpin(autoStopAfter seconds: Double, direction: Bool = true) {
        print("startSpin(autoStopAfter: \(seconds), direction: \(direction))")
        clockwise = direction
        stopWorkItem?.cancel()
        spinStartTime = Date()
        spinning = true

        let work = DispatchWorkItem { [self] in self.stopSpin() }
        stopWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
    }

    func stopSpin() {
        guard spinning else { return }
        
        // 1) Commit current transient angle to the base (no animation)
        let dynAngleNow = dynAngle
        withAnimation(.none) {
            baseAngle += (clockwise ? 1 : -1) * dynAngleNow
        }
        spinStartTime = nil

        // 2) Natural slowdown: duration scales with speed; distance = ½ v t
        let velocity = revsPerSecond * 360  // deg/s
        let rawDuration = velocity / 360  // proportional to speed (== revsPerSecond)
        let slowdownDuration = min(max(rawDuration, 0.8), 2.0)  // clamp to nice bounds
        
        stopWorkItem = DispatchWorkItem {
            withAnimation(.easeOut(duration: min(max(rawDuration, 0.8), 2.0))) {
                self.baseAngle += (self.clockwise ? 1 : -1) * 0.5 * velocity * slowdownDuration
            } completion: {
                self.spinning = false
                self.stopWorkItem = nil
            }
        }
        stopWorkItem?.perform()
        while baseAngle > 360 { baseAngle -= 360 }
        while baseAngle < 0 { baseAngle += 360 }
    }

    func hardStop() {
        guard spinning else { return }
        stopWorkItem?.cancel()
        let dynAngleNow = dynAngle
        withAnimation(.none) {
            baseAngle += (clockwise ? 1 : -1) * dynAngleNow
        }
        spinStartTime = nil
        stopWorkItem = nil
        spinning = false
        while baseAngle > 360 { baseAngle -= 360 }
        while baseAngle < 0 { baseAngle += 360 }
    }

    var resultAppendage: Appendage? {
        return switch (baseAngle / 90) {
            case 0..<1: Appendage.leftFoot
            case 1..<2: Appendage.rightHand
            case 2..<3: Appendage.rightFoot
            case 3..<4: Appendage.leftHand
            default : nil
        }
    }

    var resultColorString: LandingColor? {
        return switch (baseAngle.truncatingRemainder(dividingBy: 90.0)) {
            case 0.0..<22.5: LandingColor.green
            case 22.5..<43.0: LandingColor.red
            case 43.0..<65.5: LandingColor.yellow
            case 65.5..<90: LandingColor.blue
            default : nil
        }
    }
    
    func getResult() -> (Appendage?, LandingColor?) {

        if spinning {
            return (nil, nil)
        }
        
        return (resultAppendage, resultColorString)
    }

}
