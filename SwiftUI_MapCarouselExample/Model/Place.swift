//
//  Place.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/01/30.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id: UUID = .init()
    var name: String
    var coordinates: CLLocationCoordinate2D
    var mapItem: MKMapItem
    
    var address: String {
        if #available(iOS 26, *) {
            return mapItem.address?.fullAddress ?? ""
        } else {
            return mapItem.placemark.title ?? ""
        }
    }
    
    var phoneNumber: String? {
        return mapItem.phoneNumber
    }
}
