//
//  SearchViewModel.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//
import Foundation


@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var shouldNavigateToResults: Bool = false

    func performSearch(query: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Search text is empty")
            return
        }
        searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
}

