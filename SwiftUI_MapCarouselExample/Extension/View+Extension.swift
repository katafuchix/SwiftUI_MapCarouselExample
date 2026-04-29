//
//  View+Extension.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/01/30.
//

import SwiftUI

extension View {
    @ViewBuilder
    func optionalGlassEffect(_ colorScheme: ColorScheme, cornerRadius: CGFloat = 30) -> some View {
        let backgroundColor = colorScheme == .dark ? Color.black : Color.white
        
        if #available(iOS 26, *) {
            self
                .glassEffect(.clear.tint(backgroundColor.opacity(0.75)).interactive(), in: .rect(cornerRadius: cornerRadius, style: .continuous))
        } else {
            self
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(backgroundColor)
                }
        }
    }
}
