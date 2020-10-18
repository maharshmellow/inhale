//
//  ContentView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-16.
//

import SwiftUI

let messages = ["inhale", "hold", "exhale", "tap the circle to start"]
let pattern = [4, 7, 8] // inhale, hold, exhale

enum states: Int {
    case inhale = 0
    case hold = 1
    case exhale = 2
    case stopped = 3
}

let impactSoft = UIImpactFeedbackGenerator(style: .soft)
let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

struct ContentView: View {
    @State private var circleVar = false
    @State private var currentState = states.stopped
    @State private var timeRemaining = 0
    @State private var repsRemaining = 3
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func getCircleSize(state: states) -> Double {
        switch state {
        case .inhale:
            return 2.5
        case .hold:
            return 2.5
        case .exhale:
            return 0.8
        default:
            return 1.0
        }
    }

    var body: some View {
        VStack {
            Text("\(messages[currentState.rawValue])")
                .padding(.top, 60)
                .font(.system(size: 28, weight: .medium))
            Text("0\(timeRemaining)")
                .padding(.top, 80)
                .font(.system(size: 48, weight: .semibold))
            Spacer()
            Circle()
                .frame(width: 150, height: 150, alignment: .center)
                .scaleEffect(CGFloat(getCircleSize(state: currentState)))
                .animation(.easeInOut(duration: Double(currentState == states.stopped ? 3 : pattern[currentState.rawValue])))
                .onTapGesture {
                    impactHeavy.impactOccurred()
                    
                    if currentState == states.stopped {
                        currentState = states.inhale
                        timeRemaining = pattern[states.inhale.rawValue]
                        repsRemaining = 3
                        startTimer()
                    } else {
                        currentState = states.stopped
                        timeRemaining = 0
                        stopTimer()
                    }
                    
                    circleVar.toggle()
                }
            Spacer()
            Text("\(repsRemaining)")
                .foregroundColor(.gray)
                .font(.system(size: 32, weight: .semibold))
        }.onReceive(timer) { _ in
            if currentState == states.stopped {
                return
            }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
                impactSoft.impactOccurred()
            }
            
            if timeRemaining == 0 {
                switch currentState {
                case .inhale:
                    currentState = states.hold
                case .hold:
                    currentState = states.exhale
                case .exhale:
                    if repsRemaining == 0 {
                        currentState = states.stopped
                        stopTimer()
                        impactHeavy.impactOccurred()
                        return
                    } else {
                        currentState = states.inhale
                        repsRemaining -= 1
                    }
                case .stopped:
                    // should never occur because timer wouldn't run in the stopped state
                    return
                }
                
                timeRemaining = pattern[currentState.rawValue]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
