//
//  Cities.swift
//  TestTask
//
//  Created by sergey on 11/14/23.
//

import Foundation

struct City: Codable {
    let name: String
    let latitude, longitude: Double
    let code: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case code = "Code"
    }
}

