//
//  SearchResults.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//


import Foundation


struct PixabayResponse: Codable {
    let hits: [PixabayImage]
}

struct PixabayImage: Codable, Identifiable {
    let id: Int
    let previewURL: String
}



struct PixabayRequest: Request {
    var baseURL: String
    var path: String
    var httpMethod: HttpMethod
    var params: [String: String]
    var header: [String: String]

    init(query: String) {
        self.baseURL = "https://www.pixabay.com"
        self.path = "/api/"
        self.httpMethod = .get
        self.params = [
            "q": query,
            "key": "13197033-03eec42c293d2323112b4cca6",
            "image_type": "photo"
        ]
        self.header = [:]
    }
}
