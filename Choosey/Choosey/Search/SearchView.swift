//
//  SearchView.swift
//  Choosey
//
//  Created by Jimmy Lynch on 9/28/23.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @ObservedObject var locationManager: LocationManager
    @State private var search: String = ""
    @State private var distance: Int = 1
    @State private var price: Int? = 1
    @State private var sort: String = "best_match"
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Search", text: $vm.searchTerm)
                    NavigationLink {
                        LocationSearchView(searchLocation: $vm.searchLocation)
                    } label: {
                        switch vm.searchLocation {
                            case .current:
                                Text("Current Location")
                            case let .other(location):
                                Text("\(location.name)")
                        }
                    }
                }
                
                Section {
                    Stepper {
                        Text("Within \(vm.radius) miles")
                    } onIncrement: {
                        if (vm.radius < 24) {
                            vm.radius += 1
                        }
                    } onDecrement: {
                        if (vm.radius > 1) {
                            vm.radius -= 1
                        }
                    }
                    Picker("Price", selection: $vm.price) {
                        ForEach(SearchService.priceOptions, id:\.value) { p in
                            Text(p.title).tag(p.value)
                        }
                    }
                    
                    Picker("Sort By", selection: $vm.sort) {
                        ForEach(SearchService.sortOptions, id:\.value) { s in
                            Text(s.title).tag(s.value)
                        }
                    }
                }
                
                Section {
                    Button {
                        switch vm.searchLocation {
                            case .current:
                                findCurrentLocation()
                            
                            case let .other(location):
                                let latitude = location.latitude
                                let longitude = location.longitude
                                let _ = Task {
                                    await vm.searchBusinesses(latitude: latitude, longitude: longitude)
                                }
                        }
                            
                    } label: {
                        Text("Find Restaurants")
                            .foregroundColor(Color.blue)
                    }
                }
                
                Section {
                    switch vm.state {
                        case .idle:
                            idleView
                        case .searching:
                            searchingView
                        case let .error(error):
                            errorView(error)
                        case let .success(businesses):
                            businessList(businesses)
                    }
                }
                
            }
            .navigationTitle("Choosey!")
            .task(id: locationManager.userLocation) {
                if let location = locationManager.userLocation {
                    await loadData(currLocation: location)
                }
            }
        }
    }
    
    func findCurrentLocation() {
        vm.state = .searching
        locationManager.fetchCurrentLocation()
    }
    
    @ViewBuilder
    private var idleView: some View {
        Text("Results will load here...")
            .font(.subheadline)
        //ideally should have nothing, but need one?
    }
    
    @ViewBuilder
    private var searchingView: some View {
        // TODO: Search View
        Text("Searching...")
            .font(.subheadline)
    }
    
    @ViewBuilder
    private func businessList(_ businesses: [Business]) -> some View {
        List(businesses, id: \.id) { i in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("\(i.name)")
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    HStack(alignment: .center) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(Color.orange)
                        Text("\(String(format: "%.2f", i.rating))")
                            .font(.caption)
                            .foregroundColor(Color.orange)

                        Text("(\(i.reviewCount))")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    }
                    let addy = i.location?.displayAddress.joined(separator: ", ") ?? ""
                    Text("\(addy)")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(String(format: "%.2f", i.distance)) mi")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    if let pr = i.price {
                        Text("\(pr)")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    }
                    
                }
                
            }
            .padding(.top, 5)
            
        }
    }
    
    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        //TODO: Error View
        Text("Error")
    }
    
    @Sendable func loadData(currLocation: CLLocation?) async {
        if let currLocation = currLocation {
            await vm.searchBusinesses(latitude: currLocation.coordinate.latitude, longitude: currLocation.coordinate.longitude)
            return
        } else {
            return
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(locationManager: LocationManager())
    }
}
