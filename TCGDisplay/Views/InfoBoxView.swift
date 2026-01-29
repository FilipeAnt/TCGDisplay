//
//  InfoBoxView.swift
//  TCGDisplay
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import SwiftUI

struct InfoBoxView<Content: View>: View {
    let title: String?
    let width: CGFloat

    @ViewBuilder let content: () -> Content

    init(width: CGFloat,title: String? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.width = width
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            content()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: width)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
