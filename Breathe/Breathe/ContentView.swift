//
//  ContentView.swift
//  Breathe
//
//  Created by Maharsh Patel on 2020-10-16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("exhale")
                .padding(.top, 60)
                .font(.system(size: 26, weight: .medium))
            Text("4")
                .padding(.top, 60)
                .font(.system(size: 32, weight: .medium))
            Spacer()
            Circle()
                .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Spacer()
            Text("3")
                .foregroundColor(.gray)
                .font(.system(size: 32, weight: .medium))
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
