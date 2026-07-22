//
//  SignalistApp.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 9/07/26.
//

import SwiftUI

@main
struct SignalistApp: App {
    @StateObject private var helpCenter = HelpCenter()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(helpCenter)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .help) {
                Button("Signalist Help") {
                    helpCenter.isShowingHelp = true
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }
    }
}
