//
//  PlaceSearchService.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/04/29.
//

import MapKit

/// Map検索用クラス
class PlaceSearchService {
    func fetch(
        region: MKCoordinateRegion,
        query: String,
        limit: Int
    ) async -> [Place] {
        
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        
        // 検索実行
        guard let items = try? await search.start().mapItems else {
            return []
        }
        
        // MapItem → Placeに変換
        let places = items.compactMap { item in
            let name = item.name ?? "Unknown"
            var coordinates: CLLocationCoordinate2D
            if #available(iOS 26, *) {
                coordinates = item.location.coordinate
            } else {
                coordinates = item.placemark.coordinate
            }
            return Place(name: name, coordinates: coordinates, mapItem: item)
        }
        .prefix(limit) // 件数制限
        .map { $0 }
        
        return places
    }
}
