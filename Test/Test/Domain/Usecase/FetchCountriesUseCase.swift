
class FetchCountriesUseCase {
    private let repository: CountryRepositoryProtocol
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Country] {
        try await repository.getCountries()
    }
}
