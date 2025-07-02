//
//  PDFGenerator.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

import PDFKit
import UIKit

struct PDFGenerator {
    static func createPDF(from insights: [AIInsight]) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "FitMindAI",
            kCGPDFContextAuthor: "Muqeem Ahmad"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 595.2
        let pageHeight = 841.8
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { context in
            context.beginPage()
            var yOffset: CGFloat = 20
            let padding: CGFloat = 20

            for insight in insights {
                if yOffset > pageHeight - 100 {
                    context.beginPage()
                    yOffset = 20
                }

                let dateText = "📅 \(insight.date.formatted(date: .abbreviated, time: .shortened))"
                let summaryText = "💬 Summary: \(insight.summary)"
                let insightText = "🧠 Insight: \(insight.insight)"

                let text = "\(dateText)\n\(summaryText)\n\(insightText)\n\n"

                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14)
                ]

                let attributedText = NSAttributedString(string: text, attributes: attributes)
                let textRect = CGRect(x: padding, y: yOffset, width: pageWidth - 2 * padding, height: .greatestFiniteMagnitude)
                let size = attributedText.boundingRect(with: textRect.size, options: .usesLineFragmentOrigin, context: nil)

                attributedText.draw(in: CGRect(x: padding, y: yOffset, width: textRect.width, height: size.height))
                yOffset += size.height + 10
            }
        }

        return data
    }
}
