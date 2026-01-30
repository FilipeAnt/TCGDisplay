//
//  TCGDisplayApp.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

@main
struct TCGDisplayApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CardListView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
