//
//  CardRowView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct CardRowView: View {
    let card: PokemonCard
    @State private var reloadImage = false
    @State private var retryCount = 0

    private let maxRetries = 3
    private let retryDelay: TimeInterval = 1.0

    var body: some View {
        VStack {
            if let imageUrl = card.image, let url = URL(string: "\(imageUrl)/high.webp") {
                AsyncImage(url: url, transaction: Transaction(animation: .easeIn)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                    case .failure:
                        Image("backImgTest")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .foregroundColor(.clear)
                            .onAppear {
                                attemptRetry()
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .id(reloadImage)
            } else {
                Image("backImgTest")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .foregroundColor(.gray)
            }
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
            reloadImage.toggle()
        }
    }
}
