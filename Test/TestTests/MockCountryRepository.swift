import XCTest
@testable import Test

class MockCountryRepository: CountryRepositoryProtocol {
    var shouldReturnError = false
    
    func getCountries() async throws -> [Country] {
        if shouldReturnError {
            throw NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        
        return [
            Country(name: "Canada", region: "Americas", code: "CA", capital: "Ottawa"),
            Country(name: "France", region: "Europe", code: "FR", capital: "Paris"),
            Country(name: "Japan", region: "Asia", code: "JP", capital: "Tokyo")
        ]
    }
}

class MockFetchCountriesUseCase: FetchCountriesUseCase {
    var mockResult: Result<[Country], Error> = .success([])
    
    override func execute() async throws -> [Country] {
        switch mockResult {
        case .success(let countries): return countries
        case .failure(let error): throw error
        }
    }
}
