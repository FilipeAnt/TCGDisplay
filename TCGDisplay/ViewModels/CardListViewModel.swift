//
//  CardListViewModel.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import Foundation
import Combine

@MainActor
final class CardListViewModel: ObservableObject {
    @Published var cards: [PokemonCard] = []
    @Published var searchText: String = "" {
        didSet {
            filterCards()
        }
    }

    private var allCards: [PokemonCard] = []

    // Fetch cards from the API
    func fetchCards() async {
        do {
            let fetchedCards = try await TCGDexAPI.shared.fetchCards()
            self.allCards = fetchedCards
            filterCards() // Make sure initial list is filtered
        } catch {
            print("Failed to fetch cards:", error)
        }
    }

    // Filter cards locally based on search text
    private func filterCards() {
        if searchText.isEmpty {
            cards = allCards
        } else {
            cards = allCards.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
