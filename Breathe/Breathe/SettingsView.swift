//
//  SettingsView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-18.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsView: Bool
    
    @AppStorage("reduce_haptics") var reduceHaptics = false
    @AppStorage("inhale_time") var inhaleTime = 4
    @AppStorage("hold_time") var holdTime = 7
    @AppStorage("exhale_time") var exhaleTime = 8
    @AppStorage("reps_count") var totalReps = 3
    
    var body: some View {
        NavigationView {
            List {
                
                // don't show the disable vibrations toggle for ipad
                if UIDevice.current.userInterfaceIdiom != .pad {
                    Section {
                        Toggle(isOn: $reduceHaptics) {
                            HStack {
                                ZStack {
                                    Image(systemName: "iphone.radiowaves.left.and.right")
                                        .foregroundColor(.white)
                                        .font(.callout)
                                }.frame(width: 28, height: 28).background(Color.orange).cornerRadius(6)
                                Text("Disable Vibrations")
                            }
                        }
                    }
                }
                
                Section(header: Text("Custom Breathing Pattern")) {
                    Stepper(value: $inhaleTime, in: 1...30) {
                        HStack {
                            ZStack {
                                Image(systemName: "wave.3.left")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.blue).cornerRadius(6)
                            Text("Inhale: \(inhaleTime) \(inhaleTime == 1 ? "second" : "seconds")")
                        }
                    }
                    
                    Stepper(value: $holdTime, in: 1...30) {
                        HStack {
                            ZStack {
                                Image(systemName: "minus")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.blue).cornerRadius(6)
                            Text("Hold: \(holdTime) \(holdTime == 1 ? "second" : "seconds")")
                        }
                    }
                    
                    Stepper(value: $exhaleTime, in: 1...30) {
                        HStack {
                            ZStack {
                                Image(systemName: "wave.3.right")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.blue).cornerRadius(6)
                            Text("Exhale: \(exhaleTime) \(exhaleTime == 1 ? "second" : "seconds")")
                        }
                    }
                    
                    Stepper(value: $totalReps, in: 1...50) {
                        HStack {
                            ZStack {
                                Image(systemName: "repeat")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.green).cornerRadius(6)
                            Text("\(totalReps) \(totalReps == 1 ? "repetition" : "repetitions")")
                        }
                    }
                    
                    Button(action: {
                        inhaleTime = 4
                        holdTime = 7
                        exhaleTime = 8
                        totalReps = 3
                    }) {
                        Text("Reset breathing pattern")
                    }
                }
                
            }.listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                self.showSettingsView = false
            }) {
                Text("Done")
                    .bold()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettingsView: .constant(true))
    }
}
