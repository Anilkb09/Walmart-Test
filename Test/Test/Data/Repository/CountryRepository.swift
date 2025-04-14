import Foundation

protocol CountryRepositoryProtocol {
    func getCountries() async throws -> [Country]
}

class CountryRepository: CountryRepositoryProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCountries() async throws -> [Country] {
        return try await networkService.fetchData(from: Constants.url)
    }
}
