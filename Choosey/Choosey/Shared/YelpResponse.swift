//
//  YelpResponse.swift
//  Choosey
//
//  Created by Jimmy Lynch on 10/5/23.
//

import Foundation

struct yelpResponse: Codable {
    var businesses: [Business]
    var total: Int
    var region: Region
}

struct Business: Codable, Identifiable {
    var id: String
    var name: String
    var imageUrl: String
    var isClosed: Bool
    var reviewCount: Int
    var location: Location?
    var categories: [Category]
    var rating: Double
    var coordinates: Coordinates
    var price: String?
    var displayPhone: String
    var hours: Hours?
    var distance: Double
}

struct Category: Codable {
    var alias: String
    var title: String
}

struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}

struct Hours: Codable {
    var hourType: String
    var open: [OpenHour]
    var isOpenNow: Bool
}

struct OpenHour: Codable {
    var isOvernight: Bool
}

struct Region: Codable {
    var center: Coordinates
}

struct Location: Codable {
    var address1: String
    var address2: String?
    var address3: String?
    var city: String
    var zipCode: String
    var country: String
    var state: String
    var displayAddress: [String]
    var crossStreets: String?
}

