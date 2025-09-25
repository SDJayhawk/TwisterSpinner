//
//  SpinnerBoardView.swift
//  GameSpinner
//
//  Created by Steve Rose on 8/23/25.
//


import SwiftUI

struct SpinnerBoardView: View {
    @Binding var spinController:SpinController
    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 60)
            GeometryReader { geo in
                let side = min(geo.size.width, geo.size.height)
                ZStack {
                    DotCircle(squareFrameSize: side)
                    HandsAndFeetIcons(side: side)
                    NaturalDynamicSpinner(spinController: $spinController)
                        .frame(width: side, height: side)
                }
//                .position(x: geo.size.width / 2, y: geo.size.height / 2)
//                .background(.gray.opacity(0.10))
                .gesture(DragGesture(minimumDistance: 10)
                    .onEnded({ value in
                        // Calculate the spin duration based on the gesture velocity plus a random value < 1 sec
                        let spinDuration = min(
                            spinController.maxSlowdownTimeInSeconds,
                            max(
                                spinController.maxSlowdownTimeInSeconds * 1000,
                                abs(value.velocity.width),
                                abs(value.velocity.height)
                            ) / 1000
                        ) + Double.random(in: 0..<spinController.maxSlowdownTimeInSeconds)
                        
                        let startTopOrBottom = value.startLocation.y < geo.size.height / 2
                        let startLeftOrRight = value.startLocation.x < geo.size.width / 2
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
                        
//                        let _ = print("startTopOrBottom: \(startTopOrBottom), startLeftOrRight: \(startLeftOrRight), gAngle: \(gAngle.degrees + 180)")
                        
                        spinController.startSpin(autoStopAfter: spinDuration, direction: SpinDirection.make(direction))
                    })
                )

            }
            .padding()
            if spinController.spinning {
                Text("Spinning ...")
                    .font(.title)
                    .frame(height: 75)
            } else {
                if let spinResult = spinController.getResult() {
                    HStack {
                        Spacer()
                        AppendageInCircle(spinResult:spinResult)
                        Text("\(spinResult.appendage.displayName) on \(spinResult.landingColor.color.description.capitalized)")
                            .font(.title)
                        
                        Spacer()
                    }
                } else {
                    Text("No Result")
                        .font(.title)
                }
            }
//            Button(spinController.spinning ? "Stop" : "Spin") {
//                let stopTime = Double.random(in: 1..<2)
//                if spinController.spinning {
//                    spinController.stopSpin()
//                } else {
//                    spinController.startSpin(autoStopAfter: stopTime)
//                }
//            }
//            .buttonStyle(.borderedProminent)
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
