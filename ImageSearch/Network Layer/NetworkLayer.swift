
// TODO: Implement Caching
import Foundation

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

public protocol ServiceAPI {
    func execute<T: Decodable>(request: Request, modelName: T.Type) async throws -> T
    func fetchImage(url: URL) async throws -> Data
}

public class ServiceManager: ServiceAPI{
    public init() {}
    public func execute<T>(request: any Request, modelName: T.Type) async throws -> T where T : Decodable {
        guard let urlRequest = request.createRequest() else {
            throw ServiceError.invalidURL
        }
        
        let (data, _) =  try await URLSession.shared.data(for: urlRequest)
       
        return try JSONDecoder().decode(
             modelName.self, from: data)
    }
    public func fetchImage(url: URL) async throws -> Data {
        return Data()
    }
}
