//
//  TCGDexAPI.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import Foundation

final class TCGDexAPI {
    static let shared = TCGDexAPI()
    private let baseURL = "https://api.tcgdex.net/v2/en/cards"

    private init() {}

    func fetchCards() async throws -> [PokemonCard] {
        guard let url = URL(string: baseURL) else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode([PokemonCard].self, from: data)
        return result
    }

    func fetchCardDetail(id: String) async throws -> PokemonCardDetail {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(PokemonCardDetail.self, from: data)
        return result
    }
}

