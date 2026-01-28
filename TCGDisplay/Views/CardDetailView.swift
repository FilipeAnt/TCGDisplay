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
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let card = viewModel.card {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageUrl = card.image, let url = URL(string: "\(imageUrl)/high.webp") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 300)
                                    .cornerRadius(12)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    Text(card.name)
                        .font(.title)
                        .bold()
                    
                    if let hp = card.hp {
                        Text("HP: \(hp)")
                    }
                    if let types = card.types {
                        Text("Type: \(types.joined(separator: ", "))")
                    }
                    if let rarity = card.rarity {
                        Text("Rarity: \(rarity)")
                    }
                    if let stage = card.stage {
                        Text("Stage: \(stage)")
                    }
                    if let evolveFrom = card.evolveFrom {
                        Text("Evolves from: \(evolveFrom)")
                    }
                    
                    // Attacks
                    if let attacks = card.attacks, !attacks.isEmpty {
                        Text("Attacks")
                            .font(.headline)
                        ForEach(attacks.indices, id: \.self) { i in
                            let attack = attacks[i]
                            VStack(alignment: .leading) {
                                Text(attack.name ?? "Unknown")
                                    .bold()
                                if let cost = attack.cost {
                                    Text("Cost: \(cost.joined(separator: ", "))")
                                }
                                if let damage = attack.damage {
                                    Text("Damage: \(damage)")
                                }
                                if let effect = attack.effect {
                                    Text(effect)
                                }
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    Spacer()
                }
                .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("No card data available")
                    .padding()
            }
        }
        .navigationTitle("Card Detail")
        .onAppear {
            Task { await viewModel.fetchCardDetail(id: cardId) }
        }
    }
}

