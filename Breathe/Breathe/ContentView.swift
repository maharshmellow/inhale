//
//  ContentView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-16.
//

import SwiftUI

struct ContentView: View {
    @State private var circleVar = false
    @State var repsRemaining = 3
    
    let messages = ["inhale", "hold", "exhale", "tap the circle to start"]
    let pattern = [4, 7, 8] // inhale, hold, exhale
    
    enum states: Int {
        case inhale = 0
        case hold = 1
        case exhale = 2
        case stopped = 3
    }
    
    @State private var currentState = states.stopped
    @State var timeRemaining = 0
    
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
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
                .scaleEffect(circleVar ? 2.5 : 1)
                .animation(.easeInOut(duration: 3))
                .onTapGesture {
                    impactHeavy.impactOccurred()
                    
                    if currentState == states.stopped {
                        currentState = states.inhale
                        timeRemaining = pattern[states.inhale.rawValue]
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
            // TODO: if the timer is already half a second in and the button is pressed, the first countdown will only be half a second long -> maybe look into pausing and starting the actual timer instead of keeping it on
            if currentState == states.stopped {
                return
            }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
                impactLight.impactOccurred()
            }
            // add some logic here for switching between exhale/inhale/hold
            // use the switch case statements
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
