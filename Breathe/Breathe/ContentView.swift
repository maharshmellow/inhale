//
//  ContentView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-16.
//

import SwiftUI

let messages = ["inhale", "hold", "exhale", "tap the circle to start"]
enum states: Int {
    case inhale = 0
    case hold = 1
    case exhale = 2
    case stopped = 3
}

// duration in ms used to save the length of each session in HealthKit
private var mindfullnessDuration = 0

func sendSoftFeedback() {
    guard UserDefaults.standard.bool(forKey: "reduce_haptics") == false else {
        return
    }
    
    let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    impactSoft.impactOccurred()
}

func sendHeavyFeedback() {
    guard UserDefaults.standard.bool(forKey: "reduce_haptics") == false else {
        return
    }
    
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    impactHeavy.impactOccurred()
}

struct ContentView: View {
    @AppStorage("inhale_time") var inhaleTime = TimeConstants.defaultInhaleTime
    @AppStorage("hold_time") var holdTime = TimeConstants.defaultHoldTime
    @AppStorage("exhale_time") var exhaleTime = TimeConstants.defaultExhaleTime
    @AppStorage("reps_count") var totalReps = TimeConstants.defaultTotalReps
    
    @State private var currentState = states.stopped
    @State private var timeRemaining = 0
    @State private var repsRemaining = 0    // will get updated on start
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var showSettingsView = false
    
    func getDuration(state: states) -> Int {
        switch state {
        case .inhale:
            return inhaleTime
        case .hold:
            return holdTime
        case .exhale:
            return exhaleTime
        default:
            return 3
        }
    }
    
    func getCircleSize(state: states) -> Double {
        var multiplier = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            multiplier = 1.5
        }
        
        switch state {
        case .inhale:
            return 2.5*multiplier
        case .hold:
            return 2.5*multiplier
        case .exhale:
            return 0.8*multiplier
        default:
            return 1.0*multiplier
        }
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func saveToHealthKit() {
        print("Saved \(mindfullnessDuration)")
        
        mindfullnessDuration = 0
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.showSettingsView.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 20)
                        .opacity(0.6)
                }.sheet(isPresented: $showSettingsView) {
                    SettingsView(showSettingsView: self.$showSettingsView)
                }
            }.padding()
            
            Text(messages[currentState.rawValue])
                .padding(.top, 50)
                .font(.system(size: 28, weight: .medium))
            Text(String(format: "%02d", timeRemaining))
                .padding(.top, 80)
                .font(.system(size: 48, weight: .semibold))
            Spacer()
            Circle()
                .frame(width: 150, height: 150, alignment: .center)
                .scaleEffect(CGFloat(getCircleSize(state: currentState)))
                .animation(.easeInOut(duration: Double(currentState == states.stopped ? 3 : getDuration(state: currentState))))
                .onTapGesture {
                    sendHeavyFeedback()
                    
                    if currentState == states.stopped {
                        currentState = states.inhale
                        timeRemaining = getDuration(state: states.inhale)
                        repsRemaining = totalReps
                        startTimer()
                    } else {
                        currentState = states.stopped
                        timeRemaining = 0
                        stopTimer()
                        saveToHealthKit()
                    }
                }
            Spacer()
            Text("\(repsRemaining)")
                .foregroundColor(.gray)
                .font(.system(size: 32, weight: .semibold))
        }.onReceive(timer) { _ in
            if currentState == states.stopped {
                return
            }
            
            mindfullnessDuration += 1
            
            if timeRemaining > 0 {
                timeRemaining -= 1
                sendSoftFeedback()  // second tick
            }
            
            if timeRemaining == 0 {
                sendHeavyFeedback() // switching state
                
                switch currentState {
                case .inhale:
                    currentState = states.hold
                case .hold:
                    currentState = states.exhale
                case .exhale:
                    repsRemaining -= 1
                    if repsRemaining == 0 {
                        // finished a full cycle
                        currentState = states.stopped
                        stopTimer()
                        saveToHealthKit()
                        sendHeavyFeedback()
                        return
                    } else {
                        currentState = states.inhale
                    }
                case .stopped:
                    // should never occur because timer wouldn't run in the stopped state
                    return
                }
                
                timeRemaining = getDuration(state: currentState)
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
