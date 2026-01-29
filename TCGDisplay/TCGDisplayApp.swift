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
              TabView {
                  NavigationStack {
                      CardListView()
                  }
                  .tabItem {
                      Label("Cards", systemImage: "rectangle.grid.2x2")
                  }

                  NavigationStack {
                      //FavoritesView()
                  }
                  .tabItem {
                      Label("Favorites", systemImage: "heart")
                  }
                  .tabViewStyle(.sidebarAdaptable)
              }
              .preferredColorScheme(.dark)
          }
      }
}
