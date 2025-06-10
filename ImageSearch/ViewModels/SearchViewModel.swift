//
//  SearchViewModel.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//
import Foundation


@MainActor
class SearchViewModel: ObservableObject {
    @Published var shouldNavigateToResults: Bool = false
    
    func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Search text is empty")
            return
        }
        
    }
}

