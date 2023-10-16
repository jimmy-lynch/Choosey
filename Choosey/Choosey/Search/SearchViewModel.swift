//
//  SearchViewModel.swift
//  Choosey
//
//  Created by Jimmy Lynch on 9/28/23.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var radius: Int = 1
    
    @Published var businesses: [Business] = []
    
    func searchBusinesses(latitude: Double, longitude: Double) async {
        do {
            //TODO: Call searchServices search method
            let search = try await SearchService.findBusinesses(latitude: latitude, longitude: longitude, radius: radius, searchTerm: searchTerm)
            //TODO: ASSIGN RESULT TO CORECT PROPERTY
            businesses = search
        } catch {
            print("Error: \(error)")
        }
    }
}
