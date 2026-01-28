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

    func fetchCards() async {
        do {
            let fetchedCards = try await TCGDexAPI.shared.fetchCards()
            self.allCards = fetchedCards
            filterCards() // Make sure initial list is filtered
        } catch {
            print("Failed to fetch cards:", error)
        }
    }
    private func filterCards() {
        let trimmedSearch = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if trimmedSearch.isEmpty {
            cards = allCards
            return
        }

        let prefixMatches = allCards.filter {
            $0.name.lowercased().hasPrefix(trimmedSearch)
        }

        let fuzzyMatches = allCards.filter {
            let nameLower = $0.name.lowercased()
            return nameLower.contains(trimmedSearch) && !nameLower.hasPrefix(trimmedSearch)
        }

        cards = prefixMatches + fuzzyMatches
    }
}
