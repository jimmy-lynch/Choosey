//
//  RequestLocationView.swift
//  Choosey
//
//  Created by Jimmy Lynch on 9/28/23.
//

import SwiftUI

struct RequestLocationView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 12) {
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(.systemBlue))
                Text("We will use your location to display restaurants near you.")
                    .foregroundColor(Color(.systemBlue))
                    .bold()
                    .multilineTextAlignment(.center)
                Button {
                    locationManager.requestLocationAccess()
                } label: {
                    Text("Allow Access")
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

struct RequestLocationView_Previews: PreviewProvider {
    static var previews: some View {
        RequestLocationView(locationManager: LocationManager())
    }
}
