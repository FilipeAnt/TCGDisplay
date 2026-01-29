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
            filterCards()
        } catch {
            print("Failed to fetch cards:", error)
        }
    }
    
    private func filterCards() {
        let trimmedSearch = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let cardsWithImages = allCards.filter {
            guard let image = $0.image else { return false }
            return !image.isEmpty
        }

        if trimmedSearch.isEmpty {
            cards = cardsWithImages
            return
        }

        let prefixMatches = cardsWithImages.filter {
            $0.name.lowercased().hasPrefix(trimmedSearch)
        }

        let fuzzyMatches = cardsWithImages.filter {
            let nameLower = $0.name.lowercased()
            return nameLower.contains(trimmedSearch) && !nameLower.hasPrefix(trimmedSearch)
        }

        cards = prefixMatches + fuzzyMatches
    }

}
