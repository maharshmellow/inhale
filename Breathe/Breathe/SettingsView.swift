//
//  SettingsView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-18.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsView: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: Text("Detail View")) {
                        HStack {
                            ZStack {
                                Image(systemName: "circle")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.orange).cornerRadius(6)
                            Text("Breathing Pattern")
                        }
                    }
                    NavigationLink(destination: Text("Detail View")) {
                        HStack {
                            ZStack {
                                Image(systemName: "airplane")
                                    .foregroundColor(.white)
                                    .font(.callout)
                            }.frame(width: 28, height: 28).background(Color.blue).cornerRadius(6)
                            Text("Theme")
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
