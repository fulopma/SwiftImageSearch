//
//  LocalSearchResponse.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/11/25.
//

//struct LocalModel: Decodable {
//    let responses: [LocalResponse]
//}

//struct LocalResponse: Decodable {
//    let hits: [LocalPixabayImage]
//}
//
//struct LocalPixabayImage: Decodable {
//    let previewURL: String
//}


struct LocalResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [PixabayImage] // or whatever struct represents the image items
    let query: String
}

//struct ImageResult: Decodable {
//    let id: Int
//    let pageURL: String
//    let previewURL: String
//    // other properties...
//}
