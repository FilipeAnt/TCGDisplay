//
//  CardListViewModel.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import Foundation
import Combine

final class CardListViewModel: ObservableObject {
    // The list of cards fetched from the API
    @Published var cards: [PokemonCard] = []
    
    // Search text
    @Published var searchText: String = ""
    
    // Filtered cards based on search text
    var filteredCards: [PokemonCard] {
        if searchText.isEmpty {
            return cards
        } else {
            return cards.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    @MainActor
    func fetchCards() async {
        do {
            self.cards = try await TCGDexAPI.shared.fetchCards()
        } catch {
            print("Error fetching cards: \(error)")
            self.cards = []
        }
    }

}
