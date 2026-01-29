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
    private let imageHeight: CGFloat = 230
    private let imageCornerRadius: CGFloat = 8
    private let cornerRadius: CGFloat = 10
    private let padding: CGFloat = 10
    private let shadowRadius: CGFloat = 2

    var body: some View {
        LazyVStack {
            if let imageUrl = card.image, let url = URL(string: "\(imageUrl)/high.webp") {
                AsyncImage(url: url, transaction: Transaction(animation: .easeIn)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: imageHeight)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: imageHeight)
                            .cornerRadius(imageCornerRadius)
                    case .failure:
                        if retryCount < maxRetries {
                            ProgressView()
                                .frame(height: imageHeight)
                                .onAppear {
                                    attemptRetry()
                                }
                        } else {
                            Image("backImgTest")
                                .resizable()
                                .scaledToFit()
                                .frame(height: imageHeight)
                                .cornerRadius(imageCornerRadius)
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
                    .frame(height: imageHeight)
                    .foregroundColor(.gray)
            }
            Text(card.name)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
        .padding(padding)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(cornerRadius)
        .shadow(radius: shadowRadius)
    }

    private func attemptRetry() {
        retryCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
            reloadImage.toggle()
        }
    }
}
