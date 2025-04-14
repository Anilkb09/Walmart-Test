import Foundation
@testable import Test

class MockNetworkService: NetworkService {
    
    var shouldReturnError = false
    var mockData: [Country] = []
    
    func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        }
        
        guard let data = try? JSONEncoder().encode(mockData),
              let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return decodedData
    }
}
