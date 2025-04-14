import Foundation

class FilterCountriesUseCase {
    
    func execute(countries: [Country], query: String) -> [Country] {
        guard !query.isEmpty else {
            return countries
        }
        
        let lowercasedQuery = query.lowercased()
        
        return countries.filter { country in
            country.name.lowercased().contains(lowercasedQuery) ||
            country.capital.lowercased().contains(lowercasedQuery)
        }
    }
}
