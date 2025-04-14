import UIKit
import Combine

class CountryListViewController: UIViewController {
    
    private let viewModel: CountryListViewModel
    private let viewBuilder = CountryListViewBuilder()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        view.backgroundColor = .white
        
        setupUI()
        setupBindings()
        
        Task {
            await viewModel.fetchCountries()
        }
    }
    
    private func setupUI() {
        viewBuilder.layout(in: view)
        
        viewBuilder.tableView.delegate = self
        viewBuilder.tableView.dataSource = self
        
        navigationItem.searchController = viewBuilder.searchController
        viewBuilder.searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
    }
    
    private func setupBindings() {
        viewModel.$filteredCountries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewBuilder.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }
            .store(in: &cancellables)
    }

}

extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CountryTableViewCell.identifier,
            for: indexPath
        ) as! CountryTableViewCell
        
        let country = viewModel.filteredCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}

extension CountryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterCountries(query: searchController.searchBar.text ?? "")
    }
}
