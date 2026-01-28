//
//  CardRowView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct CardRowView: View {
    let card: PokemonCard
    @State private var reloadImage = false   // Forces AsyncImage to reload
    @State private var retryCount = 0        // Limit retries

    private let maxRetries = 3
    private let retryDelay: TimeInterval = 1.0 // seconds

    var body: some View {
        VStack {
            if let imageUrl = card.image, let url = URL(string: "\(imageUrl)/high.png") {
                AsyncImage(url: url, transaction: Transaction(animation: .easeIn)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .cornerRadius(8)
                    case .failure:
                        // Placeholder while retrying
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .foregroundColor(.gray)
                            .onAppear {
                                attemptRetry()
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .id(reloadImage) // Forces reload when toggled
            } else {
                // Fallback if no image URL
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .foregroundColor(.gray)
            }

            // Card name
            Text(card.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
        .padding(4)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private func attemptRetry() {
        guard retryCount < maxRetries else { return }
        retryCount += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
            reloadImage.toggle()  // triggers AsyncImage reload
        }
    }
}
