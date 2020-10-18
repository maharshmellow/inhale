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
            VStack {
                Text("Sheet View content")
            }
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
