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
    @State private var selectedTab: DetailTab = .details
    
    enum DetailTab: String, CaseIterable, Identifiable {
        case details = "Details"
        case prices = "Prices"
        var id: String { rawValue }
    }
    
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
                            
                            // MARK: - Card Image
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
                            
                            // MARK: - Tab Picker
                            Picker("Select Tab", selection: $selectedTab) {
                                ForEach(DetailTab.allCases) { tab in
                                    Text(tab.rawValue).tag(tab)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal, 10)
                            
                            // MARK: - Tab Content
                            VStack(spacing: 16) {
                                switch selectedTab {
                                case .details:
                                    VStack(spacing: 10) {
                                        InfoBoxView(width: geo.size.width - padding) {
                                            if let hp = card.hp {
                                                Text("HP: \(hp)")
                                            }
                                            
                                            if let types = card.types {
                                                HStack(spacing: 6) {
                                                    Text("Type: \(types.joined(separator: ", "))")
                                                    ForEach(types, id: \.self) { type in
                                                        Image(PokemonTypeIcon.assetName(for: type))
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: iconWidth, height: iconHeight)
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
                                    }
                                    
                                case .prices:
                                    InfoBoxView(width: geo.size.width - padding) {
                                        if let market = card.pricing?.cardmarket {
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Normal").bold()
                                                    HStack { Text("Low:").foregroundColor(.green); Spacer(); Text("$\(market.low ?? 0, specifier: "%.2f")") }
                                                    HStack { Text("Avg:").foregroundColor(.blue); Spacer(); Text("$\(market.avg ?? 0, specifier: "%.2f")") }
                                                    HStack { Text("Trend:").foregroundColor(.red); Spacer(); Text("$\(market.trend ?? 0, specifier: "%.2f")") }
                                                }
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Reverse Holo").bold()
                                                    HStack { Text("Low:").foregroundColor(.green); Spacer(); Text("$\(market.lowHolo ?? 0, specifier: "%.2f")") }
                                                    HStack { Text("Avg:").foregroundColor(.blue); Spacer(); Text("$\(market.avgHolo ?? 0, specifier: "%.2f")") }
                                                    HStack { Text("Trend:").foregroundColor(.red); Spacer(); Text("$\(market.trendHolo ?? 0, specifier: "%.2f")") }
                                                }
                                            }
                                            .padding(.bottom, 8)
                                        }
                                        if card.pricing?.cardmarket == nil && card.pricing?.tcgplayer == nil {
                                            Text("No price data available")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            .animation(.default, value: selectedTab)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
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
