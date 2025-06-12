
// TODO: Implement Caching
import Foundation
import Collections

public enum ServiceError: Error {
    case invalidURL
    case decodingFailed
    case fetchFailed
}

public enum HttpMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

public protocol Request {
    var baseURL: String {get set}
    var path: String {get set}
    var httpMethod: HttpMethod {get set}
    var params: [String: String] {get set}
    var header: [String: String] {get set}
}

extension Request {
    public func createRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = urlComponents?.url else {
            
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = header
        return urlRequest
    }
}
 protocol ServiceAPI {
    func readLocalResponse() -> [LocalResponse]
    func execute<T: Decodable>(request: Request, modelName: T.Type) async throws -> T
    func fetchImage(for searchTerm: String, url: String) async throws -> Data
}

public class ServiceManager: ServiceAPI{
    // "searchTerm", ["URL": ImageDataForUrl]
    private var cache: Deque<(String, [String: Data])> = []
    private var localResponses: [LocalResponse] = []
    public init() {
        cache.reserveCapacity(10)
        localResponses = readLocalResponse()
    }
    
    func readLocalResponse() -> [LocalResponse] {
        guard let url = Bundle.main.url(
            forResource: "pixabay_resultsQ",
            withExtension: "json"
        ) else {
            print("File not found")
            fatalError("no point")
        }

        guard let data = try? Data(contentsOf: url) else {
            print("Cannot read file")
            fatalError("no file readable")
        }

        let jsonDecoder = JSONDecoder()

        do {
            let responses = try jsonDecoder.decode([LocalResponse].self, from: data)
            return responses
            
        } catch {
            print("Error parsing json: \(error)")
            fatalError("No point in continuing")
        }
    }
    
    private func returnLocalResponse(query: String) -> PixabayResponse? {
        guard let response = localResponses.first (where: { $0.query == query } ) else {
            return nil
        }
        let pr = PixabayResponse(hits: response.hits)
        return pr
    }

    public func execute<T>(request: any Request, modelName: T.Type) async throws -> T where T : Decodable {
        if let response = returnLocalResponse(query: request.params["q"]?.lowercased() ?? "") {
            return response as! T 
        }
        
        guard let urlRequest = request.createRequest() else {
            throw ServiceError.invalidURL
        }
        let configuration = URLSessionConfiguration.default // Or .ephemeral, or .background
        configuration.timeoutIntervalForRequest = 10 // Set request timeout to 30 seconds
       // configuration.timeoutIntervalForResource = 300 // Set resource timeout to 300 seconds (5 minutes)

        let session = URLSession(configuration: configuration) // Initialize URLSession with the configuration
        session.configuration.httpShouldSetCookies = false
        let (data, _) =  try await session.data(for: urlRequest)
        session.finishTasksAndInvalidate()
        return try JSONDecoder().decode(
             modelName.self, from: data)
    }
    
    public func fetchImage(for searchTerm: String, url: String) async throws -> Data {
        let step1 = cache.filter({$0.0 == searchTerm})
        if step1.isEmpty {
            return try await getImageData(for: searchTerm, with: url)
        }
        guard let imageFromUrl = step1[0].1[url] else {
            return try await getImageData(for: searchTerm, with: url)
        }
        return imageFromUrl
    }
    
    private func getImageData(for searchTerm: String, with url: String) async throws -> Data {
        guard let urlObj = URL(string: url) else {
            throw NSError(domain: "Invalid URL \(url)", code: 1001, userInfo: nil)
        }
        var request = URLRequest(url: urlObj)
       request.httpMethod = "GET"
      // request.setValue("image/*", forHTTPHeaderField: "Accept")
       request.setValue("Chrome", forHTTPHeaderField: "User-Agent") // simulate browser

       let (rawData, _) = try await URLSession.shared.data(for: request)
        if cache.isEmpty {
            cache.append( (searchTerm, [url: rawData]) )
        }
        else if cache.count == 10 && cache.last?.0 != searchTerm{
            let _ = cache.popFirst()
            cache.append( (searchTerm, [url: rawData]) )
        }
        else {
            for (elementIndex, _) in cache.enumerated() {
                if cache[elementIndex].0 == searchTerm {
                    cache[elementIndex].1[url] = rawData
                    return rawData
                }
            }
        }
        return rawData
    }
}
