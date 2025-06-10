//
//  ImageCollectionViewModel.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//

import Foundation

@MainActor
class ImageGridViewModel: ObservableObject {
    @Published private var images: [PixabayImage] = []
    private let networkManager: ServiceAPI
    @Published var query: String = ""
    @Published var imageData: [Data] = []

    init(networkManager: ServiceAPI = ServiceManager()) {
        self.networkManager = networkManager
    }

    func fetchImages() async {
        let request = PixabayRequest(query: query)
        do {
            let response = try await networkManager.execute(request: request, modelName: PixabayResponse.self)
            self.images = response.hits
        } catch {
            print("Error fetching images: \(error)")
        }
        for image in images {
            do {
                imageData.append(try await networkManager.fetchImage(for: query, url: image.previewURL))
            }
            catch {
                print("\(error)\nCould not download from URL: \(image.previewURL)")
            }
        }
    }
//    
//    func downloadAndReturnImage(url: String) async -> Data? {
//        do {
//            return try await networkManager.fetchImage(for: query, url: url)
//        }
//        catch {
//            print("\(error)\nCould not download from URL: \(url)")
//            return nil
//        }
//    }
}
