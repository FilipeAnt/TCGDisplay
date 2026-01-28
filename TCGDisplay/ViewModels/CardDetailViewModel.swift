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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @MainActor
    func fetchCardDetail(id: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let fetchedCard = try await TCGDexAPI.shared.fetchCardDetail(id: id)
            self.card = fetchedCard
        } catch {
            self.errorMessage = "Failed to fetch card: \(error.localizedDescription)"
            print(error)
        }
    }
}
