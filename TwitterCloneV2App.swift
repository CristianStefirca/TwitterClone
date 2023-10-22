//
//  TwitterCloneV2App.swift
//  TwitterCloneV2
//
//  Created by Cristian Stefirca on 10.06.2023.
//

import SwiftUI

@main
struct TwitterCloneV2App: App {
    var body: some Scene {
        WindowGroup {
            AuthentificationView(isShowing: .constant(true), appState: AppState())
        }
    }
}
