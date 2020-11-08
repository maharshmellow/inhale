//
//  SettingsView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-18.
//

import SwiftUI
import HealthKit
import CoreHaptics


struct SettingsView: View {
    @Binding var showSettingsView: Bool
    
    @AppStorage("reduce_haptics") var reduceHaptics = false
    @AppStorage("inhale_time") var inhaleTime = TimeConstants.defaultInhaleTime
    @AppStorage("hold_time") var holdTime = TimeConstants.defaultHoldTime
    @AppStorage("exhale_time") var exhaleTime = TimeConstants.defaultExhaleTime
    @AppStorage("reps_count") var totalReps = TimeConstants.defaultTotalReps
    @AppStorage("save_healthkit") var saveToAppleHealth = HKManager.haveAuthorization()

    
    var body: some View {
        NavigationView {
            List {
                if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
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
                        inhaleTime = TimeConstants.defaultInhaleTime
                        holdTime = TimeConstants.defaultHoldTime
                        exhaleTime = TimeConstants.defaultExhaleTime
                        totalReps = TimeConstants.defaultTotalReps
                    }) {
                        Text("Reset breathing pattern")
                    }
                }
                
                if HKManager.isHealthKitAvailable() {
                    Section(footer: Text("The duration of each session will be saved in Apple Health as Mindful Minutes. If access has been previously revoked, this toggle will have no effect. Access will need to be granted through Settings > Privacy > Inhale.")) {
                        Toggle(isOn: $saveToAppleHealth) {
                            HStack {
                                ZStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.white)
                                        .font(.callout)
                                }.frame(width: 28, height: 28).background(Color.red).cornerRadius(6)
                                Text("Save to Apple Health")
                            }
                        }.onTapGesture {
                            print("Tap \(saveToAppleHealth)")
                            
                            // if the bool is false, this means the person just tapped it to toggle it to true
                            if !saveToAppleHealth {
                                HKManager.getAuthorization()
                            }
                        }
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
