//
//  SearchViewModel.swift
//  Choosey
//
//  Created by Jimmy Lynch on 9/28/23.
//

import Foundation

enum SearchLoadingState {
    case idle
    case searching
    case success(businesses: [Business])
    case error(error: Error)
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var radius: Int = 1
    @Published var price: Int? = 1
    @Published var sort: String = "best_match"
    
    @Published var state: SearchLoadingState = .idle
    @Published var searchLocation: SearchLocationType = .current
    
    func searchBusinesses(latitude: Double, longitude: Double) async {
        do {
            state = .searching
            let search = try await SearchService.findBusinesses(latitude: latitude, longitude: longitude, radius: radius, searchTerm: searchTerm, price: price, sort: sort)

            let convertedBusinesses = search.map { b in
                var newBusiness = b
                let distanceMeters = Measurement(value: b.distance, unit: UnitLength.meters)
                let distanceMiles = distanceMeters.converted(to: UnitLength.miles)
                newBusiness.distance = Double(distanceMiles.value)
                return newBusiness
            }
            state = .success(businesses: convertedBusinesses)
        } catch {
            state = .error(error: error)
            print("Error: \(error)")
        }
    }
}
