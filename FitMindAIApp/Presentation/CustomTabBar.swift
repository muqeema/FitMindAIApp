//
//  CustomTabBar.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 02/07/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    let items: [(icon: String, label: String)] = [
        ("heart.fill", "Today"),
        ("chart.bar.fill", "Weekly"),
        ("sparkles", "AI"),
        ("line.horizontal.3", "History"),
        ("gearshape", "Settings")
    ]

    var body: some View {
        HStack {
            ForEach(0..<items.count, id: \.self) { index in
                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: items[index].icon)
                            .font(.system(size: selectedTab == index ? 26 : 22, weight: .medium))
                            .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                            .foregroundColor(selectedTab == index ? .accentColor : .gray)

                        Text(items[index].label)
                            .font(.caption2)
                            .foregroundColor(selectedTab == index ? .accentColor : .gray)
                    }
                    .padding(.vertical, 6)
                }

                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}
