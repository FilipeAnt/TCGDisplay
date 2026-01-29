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
        LazyVStack {
            if let imageUrl = card.image, let url = URL(string: "\(imageUrl)/high.webp") {
                AsyncImage(url: url, transaction: Transaction(animation: .easeIn)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 230)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 230)
                            .cornerRadius(8)
                    case .failure:
                        if retryCount < maxRetries {
                            ProgressView()
                                .frame(height: 230)
                                .onAppear {
                                    attemptRetry()
                                }
                        } else {
                            Image("backImgTest")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 230)
                                .cornerRadius(8)
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
                    .frame(height: 230)
                    .foregroundColor(.gray)
            }

          /*  Text(card.name)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 40) */
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private func attemptRetry() {
        retryCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
            reloadImage.toggle()
        }
    }
}
