//
//  ImageCollectionViewModel.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//

import Foundation

@MainActor
class ImageGridViewModel: ObservableObject {
    @Published var images: [PixabayImage] = []
     var searchViewModel = SearchViewModel()
    private let networkManager: ServiceAPI

    init(networkManager: ServiceAPI = ServiceManager()) {
        self.networkManager = networkManager
    }

    func fetchImages() async {
        let request = PixabayRequest(query: searchViewModel.searchText)
        do {
            let response = try await networkManager.execute(request: request, modelName: PixabayResponse.self)
            self.images = response.hits
        } catch {
            print("Error fetching images: \(error)")
        }
    }
}
