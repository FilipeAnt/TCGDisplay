//
//  PokemonCardDetail.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import Foundation

// MARK: - Pokemon Card Detail
struct PokemonCardDetail: Decodable {
    let category: String?
    let id: String
    let illustrator: String?
    let image: String?
    let localId: String?
    let name: String
    let rarity: String?
    let set: CardSet?
    let variants: CardVariants?
    let variantsDetailed: [CardVariantDetail]?
    let dexId: [Int]?
    let hp: Int?
    let types: [String]?
    let evolveFrom: String?
    let description: String?
    let stage: String?
    let attacks: [CardAttack]?
    let weaknesses: [CardWeakness]?
    let retreat: Int?
    let regulationMark: String?
    let legal: CardLegal?
    let updated: String?
    let pricing: CardPricing?

    // Map JSON keys with underscores
    private enum CodingKeys: String, CodingKey {
        case category, id, illustrator, image, localId, name, rarity, set, variants
        case variantsDetailed = "variants_detailed"
        case dexId, hp, types, evolveFrom, description, stage, attacks, weaknesses, retreat
        case regulationMark, legal, updated, pricing
    }
}

// MARK: - Set
struct CardSet: Decodable {
    let cardCount: CardCount?
    let id: String?
    let logo: String?
    let name: String?
    let symbol: String?
}

struct CardCount: Decodable {
    let official: Int?
    let total: Int?
}

// MARK: - Variants
struct CardVariants: Decodable {
    let firstEdition: Bool?
    let holo: Bool?
    let normal: Bool?
    let reverse: Bool?
    let wPromo: Bool?
}

struct CardVariantDetail: Decodable {
    let type: String?
    let size: String?
}

// MARK: - Attacks
struct CardAttack: Decodable {
    let cost: [String]?
    let name: String?
    let effect: String?
    let damage: String?

    enum CodingKeys: String, CodingKey {
        case cost, name, effect, damage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        cost = try container.decodeIfPresent([String].self, forKey: .cost)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        effect = try container.decodeIfPresent(String.self, forKey: .effect)

        if let damageString = try container.decodeIfPresent(StringOrInt.self, forKey: .damage) {
            damage = damageString.value
        } else if let damageInt = try container.decodeIfPresent(Int.self, forKey: .damage) {
            damage = String(damageInt)
        } else {
            damage = nil
        }
    }
}


// MARK: - Weaknesses
struct CardWeakness: Decodable {
    let type: String?
    let value: String?
}

// MARK: - Legal
struct CardLegal: Decodable {
    let standard: Bool?
    let expanded: Bool?
}

// MARK: - Pricing
struct CardPricing: Decodable {
    let cardmarket: CardMarketPricing?
    let tcgplayer: TCGPlayerPricing?
}

struct CardMarketPricing: Decodable {
    let updated: String?
    let unit: String?
    let idProduct: Int?
    let avg: Double?
    let low: Double?
    let trend: Double?
    let avg1: Double?
    let avg7: Double?
    let avg30: Double?
    let avgHolo: Double?
    let lowHolo: Double?
    let trendHolo: Double?

    private enum CodingKeys: String, CodingKey {
        case updated, unit, idProduct, avg, low, trend, avg1, avg7, avg30
        case avgHolo = "avg-holo"
        case lowHolo = "low-holo"
        case trendHolo = "trend-holo"
    }
}

struct TCGPlayerPricing: Decodable {
    let updated: String?
    let unit: String?
    let normal: TCGPlayerPriceDetail?
    let reverseHolofoil: TCGPlayerPriceDetail?

    private enum CodingKeys: String, CodingKey {
        case updated, unit, normal
        case reverseHolofoil = "reverse-holofoil"
    }
}

struct TCGPlayerPriceDetail: Decodable {
    let productId: Int?
    let lowPrice: Double?
    let midPrice: Double?
    let highPrice: Double?
    let marketPrice: Double?
    let directLowPrice: Double?
}

enum StringOrInt: Decodable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(
                StringOrInt.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected String or Int"
                )
            )
        }
    }

    var value: String {
        switch self {
        case .int(let int): return String(int)
        case .string(let string): return string
        }
    }
}
