import XCTest
@testable import Test

@MainActor
class CountryListViewModelTests: XCTestCase {

    var mockRepository: MockCountryRepository!
    var viewModel: CountryListViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockCountryRepository()
        let fetchUseCase = FetchCountriesUseCase(repository: mockRepository)
        let filterUseCase = FilterCountriesUseCase()
        viewModel = CountryListViewModel(fetchUseCase: fetchUseCase, filterUseCase: filterUseCase)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchCountriesSuccess() async {
        await viewModel.fetchCountries()

        XCTAssertEqual(viewModel.countries.count, 3)
        XCTAssertEqual(viewModel.filteredCountries.count, 3)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchCountriesFailure() async {
        mockRepository.shouldReturnError = true

        await viewModel.fetchCountries()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.countries.isEmpty)
        XCTAssertTrue(viewModel.filteredCountries.isEmpty)
    }

    func testFilterCountriesByName() async {
        await viewModel.fetchCountries()

        viewModel.filterCountries(query: "Canada")

        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "Canada")
    }

    func testFilterCountriesByCapital() async {
        await viewModel.fetchCountries()

        viewModel.filterCountries(query: "Paris")

        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.capital, "Paris")
    }

    func testFilterCountriesWithNoMatch() async {
        await viewModel.fetchCountries()

        viewModel.filterCountries(query: "XYZ")

        XCTAssertEqual(viewModel.filteredCountries.count, 0)
    }

    func testFilterWithEmptyQueryReturnsAll() async {
        await viewModel.fetchCountries()

        viewModel.filterCountries(query: "")

        XCTAssertEqual(viewModel.filteredCountries.count, 3)
    }

    func testFilterCountriesIsCaseInsensitive() async {
        await viewModel.fetchCountries()

        viewModel.filterCountries(query: "cAnAdA")

        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "Canada")
    }
}
