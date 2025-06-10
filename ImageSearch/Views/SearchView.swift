//
//  ContentView.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = SearchViewModel()
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()

                    Text("Search for photos")
                        .font(.title2)
                        .foregroundColor(.white)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search for photos", text: $searchText)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                    )
                    .padding(.horizontal)
                    Button(action: {
                        // Perform search here
                        print("Search now tapped with: \(searchText)")
                        viewModel.performSearch(query: searchText)
                        
                    }) {
                        Text("Search Now")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }

                    Spacer()
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
