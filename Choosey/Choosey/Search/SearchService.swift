//
//  SearchService.swift
//  Choosey
//
//  Created by Jimmy Lynch on 10/5/23.
//

import Foundation

struct SearchService {
    private static let apiKey = "Bearer dEQkxvemXUVYEKDg3Rub0INPrzFtswzdSb8nBPwUqR0ANtfqrJIFYGa_-ei0q1gs0gOt_U1rxfNRCkfVodCsJdiFTDxLTIKD5J3PSYq3DXHmSVwTFbhYL6N0GR4nZXYx"
    private static let session = URLSession.shared
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    public static func findBusinesses(latitude: Double, longitude: Double, radius: Int, searchTerm: String, price: Int?, sort: String) async throws -> [Business] {
        let radiusMiles = Measurement(value: Double(radius), unit: UnitLength.miles)
        let radiusMeters = radiusMiles.converted(to: UnitLength.meters)
        
        
        var urlRaw = URLComponents(string:"https://api.yelp.com/v3/businesses/search?")
        
        urlRaw?.queryItems = [
            URLQueryItem(name: "latitude", value:"\(latitude)"),
            URLQueryItem(name: "longitude", value:"\(longitude)"),
            URLQueryItem(name: "term", value:"\(searchTerm)"),
            URLQueryItem(name: "radius", value:"\(Int(radiusMeters.value))"),
            URLQueryItem(name: "sort_by", value:"\(sort)")
            
        ]
        
        if let p = price {
            urlRaw?.queryItems?.append(URLQueryItem(name: "price", value:"\(p)"))
        }
        
        guard let url = urlRaw?.url else { fatalError("Invalid URL") }
        
        //TODO - Construct the URLRequest
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        //TODO - Make the request w/ URLSession
        let (data, _) = try await session.data(for: request)
        
        printData(data: data)
        //TODO - Decode the response using the decoder
        
        let output = try decoder.decode(yelpResponse.self, from: data)
        
        //TODO - return the businesses array from the YelpResponse
        return output.businesses
    }
    
    private static func printData(data: Data) {
        let string = String(data: data, encoding: .utf8)!
        print(string)
    }
}

extension SearchService {
    struct PriceOption {
        let title: String
        let value: Int?
    }
    
    struct SortOption {
        let title: String
        let value: String
    }
    
    public static let priceOptions: [PriceOption] = [
        .init(title: "Any", value: nil),
        .init(title: "$", value: 1),
        .init(title: "$$", value: 2),
        .init(title: "$$$", value: 3),
        .init(title: "$$$$", value: 4)
    ]
    
    public static let sortOptions: [SortOption] = [
        .init(title: "Best match", value: "best_match"),
        .init(title: "Rating", value: "rating"),
        .init(title: "Review Count", value: "review_count"),
        .init(title: "Distance", value: "distance")
    ]
}
