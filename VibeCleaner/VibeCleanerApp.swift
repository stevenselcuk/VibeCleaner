//
//  VibeCleanerApp.swift
//  VibeCleaner
//
//  Created by Steven J. Selcuk on 12.09.2025.
//

import SwiftUI


class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct cleanerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
