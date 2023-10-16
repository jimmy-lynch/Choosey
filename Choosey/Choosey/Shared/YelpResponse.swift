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
    var categories: [Category]
    var rating: Double
    var coordinates: Coordinates
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
