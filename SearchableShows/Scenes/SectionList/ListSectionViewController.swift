//
//  ListSectionViewController.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Combine
import Foundation
import UIKit

final class SectionListViewController: UIViewController {

	// MARK: - Variables
	typealias DataSource = UICollectionViewDiffableDataSource<ListSection, ListSectionItem> & CollectionDataSourceProtocol

	private let viewModel: any SectionListViewModelProtocol
	private let router: (any SectionListRouterProtocol)?

	private var cancellables: Set<AnyCancellable> = .init()
	private lazy var collectionViewLayoutProvider: MovieCollectionViewLayoutProvider = MovieCollectionViewLayout()
	private(set) lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
	lazy var collectionDataSource: DataSource = MovieCollectionDataSource(collectionView: collectionView)

	private lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		return searchController
	}()

	// MARK: - Initialization

	init(viewModel: any SectionListViewModelProtocol, router: (any SectionListRouterProtocol)?) {
		self.viewModel = viewModel
		self.router = router

		super.init(nibName: nil, bundle: nil)
		self.router?.viewController = self
	}

	required init?(coder: NSCoder) {
		fatalError("This view controller doesn't support storyboards")
	}

	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		prepareUI()
		setupCollectionView()
		bind()
		//		viewModel.searchMovies()

		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	// MARK: - Prepare UI

	func prepareUI() {

		view.backgroundColor = UIColor.white
		navigationItem.title = "Movie List"

		// add subviews
		view.addSubview(collectionView)
		setConstraints()
	}

	private func setupCollectionView() {
		collectionView.backgroundColor = .clear
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.dataSource = collectionDataSource
		collectionView.collectionViewLayout = collectionViewLayoutProvider.buildLayout()
	}

	// MARK: - Constraints

	func setConstraints() {

		let constraints = [
			collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}

	// MARK: - Bind

	func bind() {

		viewModel.dataSourcePublisher
			.receive(on: RunLoop.current)
			.sink { [weak self] state in
				guard let self else { return }
				switch state {
				case let .error(message):
					AlertPresenter.showErrorAlert(on: self, message: message) {
						//						self.viewModel.searchMovies()
					}
				case let .loaded(dataSource):
					self.collectionDataSource.update(with: dataSource)
				case .loading, .notRequested:
					break
				}
			}.store(in: &cancellables)

		viewModel.destinationPublisher.sink(receiveValue: { destination in
			switch destination {
			case .routeToDetail(let movie):
				self.router?.routeToSectionDetail(movie: movie)
			}
		}).store(in: &cancellables)
	}
}

extension SectionListViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {

		guard let searchText = searchController.searchBar.text else { return }

		if searchText.isEmpty {
			collectionDataSource.update(with: [.movie: []])
		} else {
			viewModel.searchMovies(movieName: searchText)
		}
	}
}
