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
    
    func searchBusinesses(latitude: Double, longitude: Double) async {
        do {
            state = .searching
            //TODO: Call searchServices search method
            let search = try await SearchService.findBusinesses(latitude: latitude, longitude: longitude, radius: radius, searchTerm: searchTerm, price: price, sort: sort)
            //TODO: ASSIGN RESULT TO CORECT PROPERTY
            state = .success(businesses: search)
        } catch {
            state = .error(error: error)
            print("Error: \(error)")
        }
    }
}
