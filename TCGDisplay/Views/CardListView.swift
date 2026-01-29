//
//  CardListView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct CardListView: View {
    
    private let gridSpacing: CGFloat = 16
    @StateObject private var viewModel = CardListViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: gridSpacing) {
                    ForEach(viewModel.cards, id: \.id) { card in
                        NavigationLink(destination: CardDetailView(cardId: card.id)) {
                            CardRowView(card: card)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: "Search by name")
            .navigationTitle("Pokémon Cards")
            //.navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchCards()
            }
        }
    }
}

