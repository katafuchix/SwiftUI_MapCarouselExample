//
//  BottomCarousel.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/04/29.
//

import SwiftUI

/// カルーセルカードUI
struct BottomCarouselCardView: View {
    let place: Place?
    let onTapLearnMore: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let place {
                // 実データ表示
                
                Text(place.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(place.address)
                    .lineLimit(2)
                
                // 電話リンク
                if let phoneNumber = place.phoneNumber,
                   let url = URL(string: "tel:\(phoneNumber)") {
                    Link("Phone Number: **\(phoneNumber)**", destination: url)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer(minLength: 0)
                
                // 詳細画面ボタン
                Button {
                    //expandedItem = place
                    onTapLearnMore()
                } label: {
                    Text("Learn More")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .buttonBorderShape(.capsule)
                
            } else {
                /// プレースホルダー表示（ローディング中）
                Group {
                    Text("PLACEHOLDER NAME")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Some random address here, for a placeholder reason, Thanks!")
                        .lineLimit(2)
                    
                    Text("Some Phone Number Here")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    Spacer(minLength: 0)
                    
                    Button {} label: {
                        Text("Learn More")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .buttonBorderShape(.capsule)
                }
                .disabled(true)
                .redacted(reason: .placeholder)
            }
        }
        .padding(15)
        // iOS対応のガラスエフェクト
        .optionalGlassEffect(colorScheme)
    }
}
