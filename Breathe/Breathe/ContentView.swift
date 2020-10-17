//
//  ContentView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-16.
//

import SwiftUI

struct ContentView: View {
    @State private var started = false
    @State private var circleVar = false
    @State var timeRemaining = 10
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack {
            Text("exhale")
                .padding(.top, 60)
                .font(.system(size: 28, weight: .medium))
            Text("\(timeRemaining)")
                .padding(.top, 100)
                .font(.system(size: 32, weight: .semibold))
            Spacer()
            Circle()
                .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .scaleEffect(circleVar ? 2.5 : 1)
                .animation(.easeInOut(duration: 3))
                .onTapGesture {
                    print("Tapped")
                    
                    
                    impactLight.impactOccurred()
                    
                    circleVar.toggle()
                    started.toggle()
                }
            Spacer()
            Text("3")
                .foregroundColor(.gray)
                .font(.system(size: 32, weight: .semibold))
        }.onReceive(timer) { _ in
            if !self.started {
                return
            }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                impactLight.impactOccurred()
            }
            // add some logic here for switching between exhale/inhale/hold
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
