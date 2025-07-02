//
//  AIInsightHistoryView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI

struct AIInsightHistoryView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var searchText = ""
    @State private var filterTodayOnly = false

    var filteredInsights: [AIInsight] {
        viewModel.insightHistory
            .filter {
                searchText.isEmpty ||
                $0.summary.localizedCaseInsensitiveContains(searchText) ||
                $0.insight.localizedCaseInsensitiveContains(searchText)
            }
            .filter {
                !filterTodayOnly || Calendar.current.isDateInToday($0.date)
            }
            .reversed()
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.insightHistory.isEmpty {
                    Spacer()
                    Text("No insights yet.")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(filteredInsights) { insight in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(insight.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Spacer()

                                    Button {
                                        shareInsight(insight)
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                }

                                Text(insight.summary)
                                    .font(.headline)

                                Text(insight.insight)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Toggle(isOn: $filterTodayOnly) {
                        Text("Today Only")
                    }
                    .toggleStyle(.button)
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: exportPDF) {
                        Image(systemName: "square.and.arrow.down")
                    }

                    Button(role: .destructive) {
                        InsightStorageService.clear()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }

            .navigationTitle("Insight History")
        }
    }
    
    private func shareInsight(_ insight: AIInsight) {
        let text = "📅 \(insight.date.formatted(date: .abbreviated, time: .shortened))\n\n💬 Summary: \(insight.summary)\n\n🧠 Insight: \(insight.insight)"
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        // Present share sheet
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func exportPDF() {
        let pdfData = PDFGenerator.createPDF(from: filteredInsights)
        guard let data = pdfData else { return }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Insights.pdf")
        try? data.write(to: tempURL)

        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true, completion: nil)
        }
    }

}
