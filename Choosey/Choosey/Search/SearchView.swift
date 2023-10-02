//
//  SearchView.swift
//  Choosey
//
//  Created by Jimmy Lynch on 9/28/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        Button {
            locationManager.fetchCurrentLocation()
        } label: {
            Text("Find Restaurants Near Me")
        }
        
        if let location = locationManager.userLocation {
            Text("\(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(locationManager: LocationManager())
    }
}
