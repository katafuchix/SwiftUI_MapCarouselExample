//
//  ContentView.swift
//  SwiftUI_MapCarouselExample
//
//  Created by cano on 2026/01/30.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showView: Bool = false
    var body: some View {
        NavigationStack {
            List {
                Button("Show View") {
                    showView.toggle()
                }
            }
            .navigationTitle("Map Carousel")
        }
        .fullScreenCover(isPresented: $showView) {
            CustomMapView(
                userRegion: .applePark,
                userCoordinates: MKCoordinateRegion.applePark.center,
                //lookupText: "Starbucks",
                lookupText: "喫茶店",
                limit: 5
            )
        }
    }
}

#Preview {
    ContentView()
}
