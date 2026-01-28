//
//  CardListView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = CardListViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.cards, id: \.id) { card in
                        NavigationLink(destination: CardDetailView(cardId: card.id)) {
                            CardRowView(card: card)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Pokémon Cards")
            .searchable(text: $viewModel.searchText, prompt: "Search by name")
            .task {
                await viewModel.fetchCards()
            }
        }
    }
}

