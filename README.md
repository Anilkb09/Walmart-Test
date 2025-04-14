# Walmart Test

Hi!  
Here’s a quick overview of how I approached this iOS assignment. The app is structured with clarity and scalability in mind, using **MVVM**, **Combine**, and **async/await** alongside **UIKit**.

---

## Architecture at a Glance

The app follows a modular **MVVM architecture**, with clearly separated responsibilities:

- **Model**: Plain Codable struct representing country data.
- **ViewModel**: Handles fetching, state management, and filtering logic.
- **View (ViewController)**: Renders UI and binds to the ViewModel using Combine.
- **Repository Layer**: Abstracts networking from the ViewModel, improving testability.
- **Network Layer**: Uses `URLSession` and Swift concurrency for clean async networking.

---

## What I Built

### CountryListViewController
- Displays a `UITableView` with custom cells (`CountryTableViewCell`).
- Integrates a `UISearchController` for live filtering.
- Binds to `filteredCountries` and `errorMessage` using Combine.
- Triggers `viewModel.fetchCountries()` in `viewDidLoad`.

### CountryListViewModel
- Marked as `@MainActor` for thread-safe UI updates.
- Uses `@Published` properties to drive UI updates:
  - `countries`
  - `filteredCountries`
  - `errorMessage`
- Performs filtering based on country name or capital using case-insensitive matching.
- Handles data fetching using async/await and the repository.

### CountryRepository
- Encapsulates data access logic and conforms to a protocol.
- Delegates network calls to the `APIService`, keeping ViewModel lightweight and testable.

### APIService
- Handles network requests using a generic `fetch<T: Decodable>()` method.
- Validates the response and decodes JSON with `JSONDecoder`.
- Implements error handling via a custom `NetworkError` enum.

### Country Model
- Simple `Codable` struct with `name`, `region`, `code`, and `capital`.

### CountryTableViewCell
- Custom cell using Auto Layout and `UIStackView`.
- Displays country name, region, code, and capital clearly and accessibly.
- Fully supports Dynamic Type.

---

## How It Works (End-to-End Flow)

1. The app launches and triggers `viewModel.fetchCountries()`.
2. ViewModel calls the repository, which fetches JSON from the API.
3. On success, data flows back and updates the `countries` and `filteredCountries` arrays.
4. The table view automatically reloads via Combine bindings.
5. As the user types in the search bar, `filterCountries(query:)` updates the visible list.

---

## Key Strengths

- Clear MVVM separation of concerns
- Modern Swift concurrency (async/await)
- Reactive updates with Combine
- Search with live filtering
- Scalable and testable architecture
- Works across iPhone and iPad, supports rotation and Dynamic Type

---

Thanks for reviewing!  
Let me know if you'd like to dive deeper into any part of the codebase or discuss specific trade-offs I made.
