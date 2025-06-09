//
//  ImageCollectionView.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//

import SwiftUI

struct ImageCollectionView: View {
    @StateObject private var viewModel = ImageGridViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible()),  GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.images) { image in
                        AsyncImage(url: URL(string: image.previewURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let img):
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(10)

                            case .failure:
                                Color.gray
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Cats")
            .task {
                await viewModel.fetchImages()
            }
        }
    }
}

