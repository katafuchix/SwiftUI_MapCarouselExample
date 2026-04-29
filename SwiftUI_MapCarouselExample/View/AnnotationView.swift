//
//  AnnotationView.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/04/29.
//

import SwiftUI

/// Mapピンのカスタムビュー
struct AnnotationView: View {
    let place: Place
    
    // 現在選択中のPlace ID（カルーセルと連動）
    @Binding var selectedPlaceID: UUID?
    
    @Environment(\.colorScheme) private var colorScheme
    
    // 選択中か？
    var isSelected: Bool {
        get{
            return place.id == selectedPlaceID
        }
    }
    
    var body: some View {
        Image(systemName: "cup.and.saucer.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.black)
            .padding(isSelected ? 8 : 3)
            .frame(width: isSelected ? 50 : 20, height: isSelected ? 50 : 20)
            
            // 背景円
            .background {
                Circle()
                    .fill(.white)
                    .padding(-1)
            }
            
            // 選択時アニメーション
            .animation(animation, value: isSelected)
            
            // 選択時のパルスエフェクト
            .background {
                if isSelected {
                    PulseRingView(tint: colorScheme == .dark ? .white : .gray, size: 80)
                }
            }
            
            .contentShape(.rect)
            
            // タップで選択
            .onTapGesture {
                withAnimation(animation) {
                    selectedPlaceID = place.id
                    
                }
            }
    }
    
    /// 共通アニメーション
    var animation: Animation {
        .smooth(duration: 0.45, extraBounce: 0)
    }
}
