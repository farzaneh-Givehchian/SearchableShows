# SearchableShows

## Project

This project uses an API to search throgh a list of different movies which works online and offline.

## Overview

This work assignment demonstrates a reactive MVVM architecture built on UIKit. It leverages several key technologies:

- MVVM-inspired Clean Swift(VIP): Adopts clean principles for maintainability and separation of concerns.
- Combine: Simplifies asynchronous operations and data flow management.
- Concurrency: Optimizes handling of multiple tasks simultaneously.
- UICollectionViewDiffableDataSource: Managing collection view updates seamlessly.

## Features

Search
Offline Mode: Enables functionality even without internet connectivity.

## Architecture

In order to promote a clear separation of concerns, the project follows the Model-View-ViewModel (MVVM) design pattern. By decoupling concerns, MVVM facilitates easier testing. View models encapsulate business logic, making them readily testable in isolation with mocks for dependencies. MVVM aligns perfectly with Combine's reactive paradigm. View models can expose data streams (publishers) that react to user interactions or state changes. Views can subscribe to these streams and update the UI automatically as the data evolves. This simplifies handling asynchronous operations and data flow with Combine.

- Models: Data representations without UI or navigation logic.
- ViewModels: Responsible for preparing and exposing data to the UI, handling logic, and interacting with the model layer.
- Views: Focus solely on presenting the UI and capturing user input.
- Router (Borrowing from VIP): The project incorporates a router component inspired by the VIP (View-Interactor-Presenter) architecture to manage both navigation and data passing.


**Protocol-based Communication**: View models conform to a specific protocol that the view interacts with, promoting loosely coupled communication.

**Reactive Scenes** : Each scene is implemented in a reactive manner. A dataSourcePublisher which is an AnyPublisher (a wrapper on CurrentValueSubject) provides data to the view. This wrapper prevents the view controller from directly modifying the data source; only the view model can change its value.

## Testing

The project boasts **64% code coverage**, ensuring a comprehensive testing strategy. Tests cover the following areas:

- **ViewModel Layer**: Unit tests for behavior, including user interactions (e.g.,tapAction), data fetching, and other functionalities.

- **Repository**: Unit tests for various scenarios, including fetching data from the server, reading from cache, and storing data in the cache (using mocks for dependencies).

- **Network Executer**: Tests for fetching data from the server.

- **Service Endpoint**: Tests for specific service endpoint behavior.

- **Loadable Model**: Tests for handling loading states and data.

