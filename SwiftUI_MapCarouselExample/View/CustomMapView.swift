//
//  CustomMapView.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/01/30.
//

import SwiftUI
import MapKit

struct CustomMapView: View {
    // ユーザーの表示エリア（地図の初期範囲）
    var userRegion: MKCoordinateRegion
    
    // ユーザーの現在位置
    var userCoordinates: CLLocationCoordinate2D
    
    // 検索ワード（例：カフェ、レストランなど）
    var lookupText: String
    
    // 取得する最大件数
    var limit: Int
    
    // 初期化時にカメラ位置を設定
    init(userRegion: MKCoordinateRegion, userCoordinates: CLLocationCoordinate2D, lookupText: String, limit: Int = 10) {
        self.userRegion = userRegion
        self.userCoordinates = userCoordinates
        self.lookupText = lookupText
        self.limit = limit
        
        // Mapの初期表示位置
        self._cameraPosition = .init(initialValue: .region(userRegion))
    }
    
    /// View Properties
    /// Mapのカメラ位置（アニメーションで更新される）
    @State private var cameraPosition: MapCameraPosition
    
    // 検索結果の場所リスト
    @State private var places: [Place] = []
    
    // 現在選択中のPlace ID（カルーセルと連動）
    @State private var selectedPlaceID: UUID?
    
    // 詳細表示用（sheet）
    @State private var expandedItem: Place?
    
    /// Environment Properties
    // アニメーション用ID（遷移で使用）
    @Namespace private var animationID
    
    // ダーク/ライトモード
    @Environment(\.colorScheme) private var colorScheme
    
    // 画面閉じる用
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            // Map本体
            Map(position: $cameraPosition) {
                
                // 検索結果のピン表示
                ForEach(places) { place in
                    Annotation(place.name, coordinate: place.coordinates) {
                        //AnnotationView(place)
                        AnnotationView(place: place, selectedPlaceID: $selectedPlaceID)
                    }
                }
                
                /// ユーザー位置表示（許可ある場合）
                //UserAnnotation(anchor: .center)
                
                // 自分の現在地ピン
                Annotation("My Location", coordinate: userCoordinates) {
                    Circle()
                        .fill(.blue)
                        .frame(width: 20, height: 20)
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }
                }
            }
            
            /// データ取得中は暗いオーバーレイ表示
            .overlay {
                LoadingOverlay()
            }
            
            /// 下部カルーセル（Mapの利用規約を隠さないためInset使用）
            .safeAreaInset(edge: .bottom, spacing: 0) {
                GeometryReader {
                    let size = $0.size
                    
                    BottomCarousel(size: size, places: places, animationID: animationID, expandedItem: $expandedItem, selectedPlaceID: $selectedPlaceID, cameraPosition: $cameraPosition)
                    
                    /// データ未取得時のプレースホルダー
                    if places.isEmpty {
                        BottomCarouselCardView(place: nil, onTapLearnMore: {})
                            .padding(.horizontal, 15)
                            .frame(width: size.width, height: size.height)
                    }
                }
                .frame(height: 200)
            }
            
            .navigationTitle("Nearby Places")
            .navigationBarTitleDisplayMode(.inline)
            
            // 閉じるボタン
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if #available(iOS 26, *) {
                        Button(role: .close) {
                            dismiss()
                        }
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Color.primary)
                        }
                    }
                }
            }
        }
        
        // 詳細画面（sheet）
        .sheet(item: $expandedItem) { place in
            DetailView(place: place)
                .navigationTransition(.zoom(sourceID: place.id, in: animationID))
        }
        
        // 初回表示時にデータ取得
        .onAppear {
            guard places.isEmpty else { return }
            fetchPlaces()
        }
    }
    
    /// ローディング時の暗い背景
    @ViewBuilder
    private func LoadingOverlay() -> some View {
        Rectangle()
            .fill(.black.opacity(places.isEmpty ? 0.35 : 0))
            .ignoresSafeArea()
    }

    /// Map検索（MKLocalSearch）
    private func fetchPlaces() {
        Task {
            let service = PlaceSearchService()
            // 検索実行
            let places = await service.fetch(
                region: userRegion,
                query: lookupText,
                limit: limit
            )
            
            // アニメーション付きで反映
            withAnimation(animation) {
                self.places = places
                self.selectedPlaceID = places.first?.id
            }
        }
    }
    
    /// 共通アニメーション
    var animation: Animation {
        .smooth(duration: 0.45, extraBounce: 0)
    }
}

struct DetailView: View {
    var place: Place
    
    var body: some View {
        Text("This is a Detail View")
            .presentationDetents([.medium])
    }
}
#Preview {
    CustomMapView(
        userRegion: .applePark,
        userCoordinates: MKCoordinateRegion.applePark.center,
        lookupText: "Starbucks",
        limit: 5
    )
}
