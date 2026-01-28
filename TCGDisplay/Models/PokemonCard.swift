//
//  PokemonCard.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import Foundation

struct PokemonCard: Identifiable, Decodable {
    let id: String
    let name: String
    let image: String? // optional URL string
}
