//
//  CardListView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = CardListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredCards) { card in
                NavigationLink(destination: CardDetailView(cardId: card.id)) {
                    Text(card.name)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Pokémon")
            .navigationTitle("Pokémon Cards")
            .onAppear {
                Task { await viewModel.fetchCards() }
            }
        }
    }
}
