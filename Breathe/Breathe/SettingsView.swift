//
//  SettingsView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-18.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsView: Bool
    
    @State var test: Bool = false
    @State var repCounter: Int = 3
    
    @AppStorage("reduce_haptics") var reduceHaptics = false
    @AppStorage("inhale_time") var inhaleTime = 4
    @AppStorage("hold_time") var holdTime = 7
    @AppStorage("exhale_time") var exhaleTime = 8
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: Text("Detail View")) {
                        HStack {
                            ZStack {
                                Image(systemName: "moon.fill")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.black).cornerRadius(6)
                            Text("Theme")
                        }
                    }
                    
                    Toggle(isOn: $reduceHaptics) {
                        HStack {
                            ZStack {
                                Image(systemName: "iphone.radiowaves.left.and.right")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.orange).cornerRadius(6)
                            Text("Reduce Haptics")
                        }
                    }
                    // add stats -> number of focus exercises done (use the user defaults storage to count)
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
                    
                    Stepper(value: $repCounter, in: 1...50) {
                        HStack {
                            ZStack {
                                Image(systemName: "repeat")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.gray).cornerRadius(6)
                            Text("\(repCounter) \(repCounter == 1 ? "repetition" : "repetitions")")
                        }
                    }
                    
                    Button(action: {
                        inhaleTime = 4
                        holdTime = 7
                        exhaleTime = 8
                        repCounter = 3
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
