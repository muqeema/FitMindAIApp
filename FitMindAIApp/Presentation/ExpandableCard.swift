//
//  ExpandableCard.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 02/07/25.
//

import SwiftUI

struct ExpandableCard: View {
    let title: String
    let summary: String
    let details: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }

            Text(summary)
                .font(.subheadline)

            if isExpanded {
                Text(details)
                    .font(.body)
                    .transition(.opacity)
            }
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(12)
        .shadow(radius: 3)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}
