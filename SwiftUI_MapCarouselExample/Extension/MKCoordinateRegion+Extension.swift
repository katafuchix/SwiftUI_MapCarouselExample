//
//  MKCoordinateRegion+Extension.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/01/30.
//

import MapKit

extension MKCoordinateRegion {
    /// Acts as user current location!
    static var applePark: Self {
        Self(
            center: CLLocationCoordinate2D(latitude: 35.7031186, longitude: 139.5798218),
            latitudinalMeters: 2500,
            longitudinalMeters: 2500
        )
    }
}
