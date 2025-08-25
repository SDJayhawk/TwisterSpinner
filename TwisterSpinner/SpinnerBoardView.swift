//
//  SpinnerBoardView.swift
//  TwisterSpinner
//
//  Created by Steve Rose on 8/23/25.
//


import SwiftUI

struct SpinnerBoardView: View {
    @Binding var spinController:SpinController
    var body: some View {
        VStack {
            Text("Twister Spinner")
                .font(.largeTitle)
            GeometryReader { geo in
                let side = min(geo.size.width, geo.size.height)
                ZStack {
                    DotCircle(side: side)
                    HandsAndFeetIcons(side: side)
                    NaturalDynamicSpinner(size: geo.size, spinController: $spinController)
                }
                .frame(width: side, height: side)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                .gesture(DragGesture(minimumDistance: 10)
                    .onEnded({ value in
                        let _ = print(geo.size)
                        let _ = print(value)
                        let spinDuration = min(
                            2,
                            max(
                                2000,
                                abs(value.velocity.width),
                                abs(value.velocity.height)
                            ) / 1000
                        ) + Double.random(in: 0..<1)
                        
                        let _ = print("Velocity: \(spinDuration)")
                        let startTopOrBottom = value.startLocation.y < geo.size.height / 2
                        let startLeftOrRight = value.startLocation.x < geo.size.width / 2
//                        let upOrDown = value.startLocation.y > value.location.y
//                        let leftOrRight = value.startLocation.x > value.location.x
                        let gAngle = angle(from: value.startLocation, to: value.location)
                        
                        // TODO: diagnals are buggy. Maybe take the current pointer angle into account?
                        let direction = switch gAngle.degrees + 180 {
                            case 0..<45, 315...360 :
                                !startTopOrBottom
                            case 45..<135:
                                startLeftOrRight
                            case 135..<225:
                                startTopOrBottom
                            case 225..<315:
                                !startLeftOrRight
                            default:
                                true
                        }
                        
                        let _ = print("startTopOrBottom: \(startTopOrBottom), startLeftOrRight: \(startLeftOrRight), gAngle: \(gAngle.degrees + 180)")
                        
                        spinController.startSpin(autoStopAfter: spinDuration, direction: direction)
                    })
                )

            }
            .padding()
            if spinController.spinning {
                Text("Spinning ...")
                    .font(.largeTitle)
            } else {
                Text("\(spinController.resultAppendage?.displayName ?? "?") on \(spinController.resultColorString?.color.description ?? "?")")
                    .font(.largeTitle)
            }
            Button(spinController.spinning ? "Stop" : "Spin") {
                let stopTime = Double.random(in: 1..<2)
                if spinController.spinning {
                    spinController.hardStop()
                } else {
                    spinController.startSpin(autoStopAfter: stopTime)
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer(minLength: 40)
        }
    }
}

func angle(from referencePoint: CGPoint, to targetPoint: CGPoint) -> Angle {
        let dx = targetPoint.x - referencePoint.x
        let dy = targetPoint.y - referencePoint.y
        let radians = atan2(dy, dx)
        return Angle(radians: radians)
    }
