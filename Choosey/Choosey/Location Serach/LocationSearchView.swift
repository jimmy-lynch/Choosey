//
//  LocationSearchView.swift
//  Choosey
//
//  Created by Jimmy Lynch on 10/22/23.
//

import SwiftUI

struct LocationSearchView: View {
    @Environment (\.dismiss) private var dismiss: DismissAction
    @FocusState private var focused: Bool?
    @StateObject private var vm = LocationSearchViewModel()
    @Binding var searchLocation: SearchLocationType
    
    var body: some View {
        Form {
            Section {
                Button {
                    searchLocation = .current
                    dismiss()
                } label: {
                    Text("Use Current Location")
                        .foregroundColor(Color.blue)
                }
            }
            
            Section("Enter a location") {
                TextField("Enter a location", text: $vm.searchTerm)
                    .focused($focused, equals: true)
                    .onAppear { focused = true }
                
                Button("Search") {
                    vm.findLocations()
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
                    case let .success(locations):
                        locationList(locations)
                }
            }
        }
    }
    
    
    @ViewBuilder
    private var idleView: some View {
        Text("Results will load here...")
            .font(.subheadline)
    }
    
    @ViewBuilder
    private var searchingView: some View {
        // TODO: Search View
        Text("Searching...")
            .font(.subheadline)
    }
    
    @ViewBuilder
    private func locationList(_ locations: [OtherSearchLocation]) -> some View {
        List(locations, id: \.id) { l in
            Button {
                searchLocation = .other(location: l)
                dismiss()
            } label: {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(l.name)
                            .font(.headline)
                        Text(l.address)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    }
                }
                .padding(.top, 5)
            }
        }
    }
    
    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        //TODO: Error View
        Text("Error: \(error.localizedDescription)")
    }
}

#Preview {
    LocationSearchView(searchLocation: .constant(.current))
}
