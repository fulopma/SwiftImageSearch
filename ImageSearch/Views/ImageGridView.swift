//
//  ImageCollectionView.swift
//  ImageSearch
//
//  Created by Marcell Fulop on 6/9/25.
//

import SwiftUI

struct ImageGridView: View {
    
    @ObservedObject var viewModel: ImageGridViewModel
    init(query: String){
        self.viewModel = ImageGridViewModel(query: query)
    }
    // searchModelView
    // viewModel.query = searchbar.text
    let columns = [GridItem(.flexible()), GridItem(.flexible()),  GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.imageData, id: \.self) { image in
//                        AsyncImage(url: URL(string: image.previewURL)) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView()
//                            case .success(let img):
//                                img
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 100, height: 100)
//                                    .clipped()
//                                    .cornerRadius(10)
//
//                            case .failure:
//                                Color.gray
//                            @unknown default:
//                                EmptyView()
//                            }
//                        }
                        Image(uiImage: UIImage(data: image) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(10)
                            
                    }
                    
                    
                }
                .padding()
            }
            .navigationTitle(viewModel.query)
            .task {
                await viewModel.fetchImages()
              
            }
        }
    }
    
    
}

//struct ImageFromDataView: View {
//    let imageData: Data?
//
//    var body: some View {
//        if let data = imageData,
//           let uiImage = UIImage(data: data) {
//            Image(uiImage: uiImage)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        } else {
//            // Placeholder if data is nil or conversion fails
//            Image(systemName: "photo")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.gray)
//        }
//    }
//}

#Preview {
    ImageGridView(query: "House")
}
