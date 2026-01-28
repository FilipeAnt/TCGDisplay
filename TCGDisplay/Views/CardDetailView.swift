//
//  CardDetailView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct CardDetailView: View {
    let cardId: String
    @StateObject private var viewModel = CardDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let card = viewModel.card {
                Text(card.name)
                    .font(.title)
                Text("HP: \(card.hp ?? "-")")
                Text("Rarity: \(card.rarity ?? "-")")
                if let types = card.types {
                    Text("Types: \(types.joined(separator: ", "))")
                }
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .navigationTitle("Card Detail")
        .onAppear {
            viewModel.fetchCardDetail(id: cardId)
        }
    }
}
