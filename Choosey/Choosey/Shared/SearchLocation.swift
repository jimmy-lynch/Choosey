//
//  SearchLocation.swift
//  Choosey
//
//  Created by Jimmy Lynch on 10/22/23.
//

import Foundation

enum SearchLocationType {
    case current
    case other(location: OtherSearchLocation)
}

struct OtherSearchLocation: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}
