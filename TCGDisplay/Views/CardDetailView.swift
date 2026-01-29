//
//  CardDetailView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct CardDetailView: View {
    
    let cardId: String
    private let padding: CGFloat = 20
    private let iconWidth: CGFloat = 20
    private let iconHeight: CGFloat = 20
    @StateObject private var viewModel = CardDetailViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .gray, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            GeometryReader { geo in
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let card = viewModel.card {
                        VStack(alignment: .center, spacing: 16) {
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
                                                        
                            InfoBoxView(width: geo.size.width - padding) {
                                
                                if let hp = card.hp {
                                    Text("HP: \(hp)")
                                }
                                
                                if let types = card.types {
                                    HStack(spacing: 6) {
                                        Text("Type: \(types.joined(separator: ", "))")
                                        if let types = card.types {
                                            ForEach(types, id: \.self) { type in
                                                Image(PokemonTypeIcon.assetName(for: type))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: iconWidth, height: iconHeight)
                                            }
                                        }
                                    }
                                }
                                
                                if let rarity = card.rarity {
                                    Text("Rarity: \(rarity)")
                                }
                                
                                if let evolveFrom = card.evolveFrom {
                                    Text("Evolves from: \(evolveFrom)")
                                }
                            }
                            // Attacks
                            if let attacks = card.attacks, !attacks.isEmpty {
                                InfoBoxView(width: geo.size.width - padding, title: "Attacks") {
                                    ForEach(attacks.indices, id: \.self) { i in
                                        let attack = attacks[i]
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(attack.name ?? "Unknown")
                                                .bold()
                                            
                                            if let cost = attack.cost {
                                                Text("Cost: \(cost.joined(separator: ", "))")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                            
                                            if let damage = attack.damage {
                                                Text("Damage: \(damage)")
                                            }
                                            
                                            if let effect = attack.effect {
                                                Text(effect)
                                                    .font(.footnote)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                        if i != attacks.indices.last {
                                            Divider()
                                        }
                                    }
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
                .onAppear {
                    Task { await viewModel.fetchCardDetail(id: cardId) }
                }
            }
        }
    }
}

