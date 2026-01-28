//
//  PokemonCardDetail.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import Foundation

struct PokemonCardDetail: Decodable {
    let id: String
    let name: String
    let supertype: String?
    let subtypes: [String]?
    let hp: String?
    let types: [String]?
    let rarity: String?
    let images: CardImages?
    let attacks: [CardAttack]?
    let weaknesses: [CardWeakness]?
    let resistances: [CardResistance]?
    let retreatCost: [String]?
}

// MARK: - Nested structs

struct CardImages: Decodable {
    let small: String?
    let large: String?
}

struct CardAttack: Decodable {
    let name: String?
    let cost: [String]?
    let damage: String?
    let text: String?
}

struct CardWeakness: Decodable {
    let type: String?
    let value: String?
}

struct CardResistance: Decodable {
    let type: String?
    let value: String?
}
