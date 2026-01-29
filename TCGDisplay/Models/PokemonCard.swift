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
    let hp: Int?
    let types: [String]?
}

enum PokemonTypeIcon {
    static func assetName(for type: String) -> String {
        switch type.lowercased() {
        case "fire": return "fire_type_icon"
        case "water": return "water_type_icon"
        case "grass": return "grass_type_icon"
        case "lightning": return "lightning_type_icon"
        case "psychic": return "psychic_type_icon"
        case "fighting": return "fighting_type_icon"
        case "darkness": return "darkness_type_icon"
        case "metal": return "metal_type_icon"
        case "fairy": return "fairy_type_icon"
        case "dragon": return "dragon_type_icon"
        case "colorless": return "colorless_type_icon"
        default: return "type_unknown"
        }
    }
}
