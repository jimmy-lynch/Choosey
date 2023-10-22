//
//  LocationSearchViewModel.swift
//  Choosey
//
//  Created by Jimmy Lynch on 10/22/23.
//

import Foundation
import MapKit

enum LocationSearchLoadingState {
    case idle
    case searching
    case success(locations: [OtherSearchLocation])
    case error(error: Error)
}

class LocationSearchViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var state: LocationSearchLoadingState = .idle
    
    func findLocations() {
        self.state = .searching
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchTerm
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            if let e = error {
                self.state = .error(error: e)
                return
            }
            
            if let r = response?.mapItems {
                
                let output: [OtherSearchLocation] = r.map { i in
                    let name = i.name ?? ""
                    let address = i.placemark.title ?? ""
                    let latitude = i.placemark.coordinate.latitude
                    let longitude = i.placemark.coordinate.longitude
                    
                    let result = OtherSearchLocation(name: name, address: address, latitude: latitude, longitude: longitude)
                    return result
                }
                
                self.state = .success(locations: output)
            }
            
        }
    }
}
