//
//  swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/19/25.
//

import Foundation
import SwiftUI
import AVFoundation

@Observable class SpinController {
    var spinning = false
    var spinDirection = SpinDirection.clockwise
    var baseAngle: Double = Double.random(in: 0...360)
    var spinStartTime: Date? = nil
    var stopWorkItem: DispatchWorkItem?
    var history: History
   
    let revsPerSecond: Double

    let _360 = 360.0
    let _90 = 90.0
    let spinDurationSeconds = 0.3
    let circleDegrees = 22.5
    let circleLandingBorderWidth = 2.5
    let landingAngleBorderAdjustment = 2.0
    let minSlowdownTimeInSeconds = 0.5
    let maxSlowdownTimeInSeconds = 1.0

    init(inHistory: [String] = []) {
        self.history = History()
        revsPerSecond = 1 / spinDurationSeconds // ~3.33 rev/s
    }
    
    var dynAngle: Double {
        guard let start = spinStartTime?.timeIntervalSinceReferenceDate
        else { return 0 }
        
        let elapsed = Date().timeIntervalSinceReferenceDate - start
        return (spinDirection.spinModifier * elapsed * revsPerSecond * _360).truncatingRemainder(
            dividingBy: _360
        )
    }

    var rotationEffectDegrees: Angle {
        .degrees(baseAngle + dynAngle)
    }
    
    func startSpin(autoStopAfter seconds: Double, direction: SpinDirection = .clockwise) {
//        print("startSpin(autoStopAfter: \(seconds), direction: \(direction))")
        spinDirection = direction
        stopWorkItem?.cancel()
        spinStartTime = Date()
        spinning = true

        let work = DispatchWorkItem { [self] in self.stopSpin() }
        stopWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
    }

    fileprivate func adjustBaseAngleTo360() {
        while baseAngle >= _360 { baseAngle -= _360 }
        while baseAngle < 0 { baseAngle += _360 }
    }
    
    // Adjusts the final angle of the spin when it's close between 2 colors.
    fileprivate func adjustFinalAngleWhenCloseBetweenTwoColors() {
        var angleWithinTargetCircle = baseAngle
        while angleWithinTargetCircle >= _360 { angleWithinTargetCircle -= _360 }
        while angleWithinTargetCircle < 0 { angleWithinTargetCircle += _360 }
        angleWithinTargetCircle = angleWithinTargetCircle.truncatingRemainder(dividingBy: circleDegrees)
        if angleWithinTargetCircle > circleDegrees - circleLandingBorderWidth {
            baseAngle -= landingAngleBorderAdjustment
        } else if angleWithinTargetCircle < circleLandingBorderWidth {
            baseAngle += landingAngleBorderAdjustment
        }
    }
    
    func stopSpin() {
        guard spinning else { return }
        
        // 1) Commit current transient angle to the base (no animation)
        let dynAngleNow = dynAngle
        withAnimation(.none) {
            baseAngle += spinDirection.spinModifier * dynAngleNow
        }
        spinStartTime = nil

        // 2) Natural slowdown: duration scales with speed; distance = ½ v t
        let velocity = revsPerSecond * _360  // deg/s
        let rawDuration = velocity / _360  // proportional to speed (== revsPerSecond)
        let slowdownDuration = min(max(rawDuration, minSlowdownTimeInSeconds), maxSlowdownTimeInSeconds)  // clamp to nice bounds
        
        stopWorkItem = DispatchWorkItem { [self] in
            withAnimation(.easeOut(duration: slowdownDuration)) {
                baseAngle += spinDirection.spinModifier * minSlowdownTimeInSeconds * velocity * slowdownDuration
                adjustFinalAngleWhenCloseBetweenTwoColors()
            } completion: { [self] in
                spinning = false
                stopWorkItem = nil
            }
        }
        stopWorkItem?.perform()
        adjustBaseAngleTo360()

        if let result=getResult() {
            history.add(result)
        }
    }

    var resultAppendage: Appendage? {
        return switch (baseAngle / _90) {
            case 0..<1: Appendage.leftFoot
            case 1..<2: Appendage.rightHand
            case 2..<3: Appendage.rightFoot
            case 3...4: Appendage.leftHand
            default : nil
        }
    }

    var resultColor: LandingColor? {
//        print("within circle \(self.baseAngle.truncatingRemainder(dividingBy: 22.5))")
        return switch (baseAngle.truncatingRemainder(dividingBy: _90)) {
            case 0.0..<circleDegrees: LandingColor.green
            case circleDegrees..<2*circleDegrees: LandingColor.red
            case 2*circleDegrees..<3*circleDegrees: LandingColor.yellow
            case 3*circleDegrees..._90: LandingColor.blue
            default : nil
        }
    }
    
    func getResult() -> SpinResult? {
        guard let resultAppendage = resultAppendage, let resultColorString = resultColor else {
            return nil
        }
                
        return SpinResult(appendage: resultAppendage, landingColor: resultColorString)
    }
    
    func clearHistory() {
        history = History()
    }

}

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
    case red
    case yellow
    case blue
    
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

enum SpinDirection {
    case clockwise
    case counterClockwise
    
    static func make(_ clockwise: Bool) -> SpinDirection {
        return clockwise ? .clockwise : .counterClockwise
    }
    
    var spinModifier: Double {
        return switch self {
            case .clockwise:
                1
            case .counterClockwise:
                -1
        }
    }
}
