//
//  BottomCarousel.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/04/29.
//

import SwiftUI
import MapKit

/// 下部カルーセル
struct BottomCarousel: View {
    let size: CGSize
    let places: [Place]
    
    // アニメーション用ID（遷移で使用）
    let animationID: Namespace.ID
    
    // 詳細表示用（sheet）
    @Binding var expandedItem: Place?
    
    // 現在選択中のPlace ID（カルーセルと連動）
    @Binding var selectedPlaceID: UUID?
    
    /// Mapのカメラ位置（アニメーションで更新される）
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                
                // 各Placeカード
                ForEach(places) { place in
                    BottomCarouselCardView(
                        place: place,
                        onTapLearnMore: {
                            expandedItem = place
                        }
                    )
                    .padding(.horizontal, 15)
                    .frame(width: size.width, height: size.height)
                    .matchedTransitionSource(id: place.id, in: animationID)
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .scrollTargetBehavior(.paging)
        
        // スクロール位置と選択を同期
        .scrollPosition(id: $selectedPlaceID, anchor: .center)
        
        // カード切り替え → Map移動
        .onChange(of: selectedPlaceID) { oldValue, newValue in
            guard let coordinates = places.first(where: { $0.id == newValue })?.coordinates else {
                return
            }
            
            withAnimation(animation) {
                cameraPosition = .camera(.init(centerCoordinate: coordinates, distance: 25000))
            }
        }
    }
    
    /// 共通アニメーション
    var animation: Animation {
        .smooth(duration: 0.45, extraBounce: 0)
    }
}
