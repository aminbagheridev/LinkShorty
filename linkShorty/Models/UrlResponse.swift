// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uRLResponse = try? newJSONDecoder().decode(URLResponse.self, from: jsonData)

import Foundation

// MARK: - URLResponse
struct URLResponse: Codable {
    let url: URLClass?
}

// MARK: - URLClass
struct URLClass: Codable {
    let status: Int?
    let fullLink: String?
    let date: String?
    let shortLink: String?
    let title: String?
}

