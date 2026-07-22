//
//  RootView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Morse", systemImage: "dot.radiowaves.left.and.right")
                }
            
            BrailleView()
                .tabItem {
                    Label("Braille", systemImage: "hand.point.up.braille.fill")
                }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(HelpCenter())
}
