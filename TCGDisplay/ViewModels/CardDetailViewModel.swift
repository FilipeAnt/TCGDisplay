//
//  CardDetailViewModel.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import Combine
import Foundation

final class CardDetailViewModel: ObservableObject {
    @Published var card: PokemonCardDetail?
    
    // Placeholder fetch function
    func fetchCardDetail(id: String) {
        self.card = PokemonCardDetail(
            id: id,
            name: "Pikachu",
            supertype: "Pokémon",
            subtypes: ["Basic"],
            hp: "60",
            types: ["Electric"],
            rarity: "Common",
            images: CardImages(small: nil, large: nil),
            attacks: nil,
            weaknesses: nil,
            resistances: nil,
            retreatCost: nil
        )
    }
}
