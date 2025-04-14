import Foundation
import Combine

@MainActor
class CountryListViewModel: ObservableObject {
    private let fetchCountriesUseCase: FetchCountriesUseCase
    private let filterCountriesUseCase: FilterCountriesUseCase
    
    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var errorMessage: String?
    
    init(fetchUseCase: FetchCountriesUseCase, filterUseCase: FilterCountriesUseCase) {
        self.fetchCountriesUseCase = fetchUseCase
        self.filterCountriesUseCase = filterUseCase
    }
    
    func fetchCountries() async {
        do {
            countries = try await fetchCountriesUseCase.execute()
            filteredCountries = countries
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func filterCountries(query: String) {
        filteredCountries = filterCountriesUseCase.execute(countries: countries, query: query)
    }
}
