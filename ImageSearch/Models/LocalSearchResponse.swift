


struct LocalResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [PixabayImage] 
    let query: String
}
