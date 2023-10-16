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
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Search", text: $vm.searchTerm)
                    Stepper {
                        Text("Within \(vm.radius) miles")
                    } onIncrement: {
                        vm.radius += 1;
                    } onDecrement: {
                        if (vm.radius > 1) {
                            vm.radius -= 1
                        }
                    }
                    Button {
                        locationManager.fetchCurrentLocation()
                    } label: {
                        Text("Find Restaurants Near Me")
                            .foregroundColor(Color.blue)
                    }
                }
                Section {
                    List(vm.businesses, id: \.id) { i in
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text("\(i.name)")
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                HStack(alignment: .center) {
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .foregroundColor(Color.orange)
                                    Text("\(i.rating)")
                                        .font(.caption)
                                        .foregroundColor(Color.orange)

                                    Text("\(i.reviewCount)")
                                        .font(.caption)
                                        .foregroundColor(Color.gray)

                                }
                            }
                            Spacer()
                            Text("\(Double(round(i.distance*10) / 10.0))")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                        }
                        .padding(.top, 5)
                        
                    }
                }
                
            }
            .navigationTitle("Choosey!")
        }
        .task(id: locationManager.userLocation) {
            if let location = locationManager.userLocation {
                await loadData(currLocation: location)

            }
        }
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
