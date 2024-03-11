//
//  ListSectionViewModel.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//
import Combine
import Foundation

enum Destination {
	case routeToDetail(MovieModel)
}
protocol SectionListViewModelProtocol {
	typealias SectionState = Loadable<[ListSection: [ListSectionItem]]>
	var dataSourcePublisher: AnyPublisher<SectionState, Never> { get }
	var destinationPublisher: AnyPublisher<Destination,Never>  { get }
	func searchMovies(movieName: String)
}

final class SectionListViewModel: SectionListViewModelProtocol {

	private let repository: SectionUsecase
	private var cancellable: AnyCancellable?

	private let datasourceSubject: CurrentValueSubject<SectionState, Never>
	var dataSourcePublisher: AnyPublisher<SectionState, Never> {
		datasourceSubject.eraseToAnyPublisher()
	}

	private let destination: PassthroughSubject<Destination,Never> = .init()
	var destinationPublisher: AnyPublisher<Destination,Never> {
		destination.eraseToAnyPublisher()
	}

	init(sectionUsecase: SectionUsecase) {
		self.repository = sectionUsecase
		self.datasourceSubject = .init(.notRequested)
	}

	func searchMovies(movieName: String) {
		Task(priority: .high) {
			do {
				let sections = try await repository.searchMovie(movieName: movieName)
				datasourceSubject.value = .loaded([
					.movie : sections.map({  section in
						ListSectionItem.movie(
							MovieBannerConfiguration.init(section: section) { [weak self] in
								self?.sectionSelected(section: section)
							}
						)
					})
				])
			} catch {
				datasourceSubject.value = .error(AppError(reason: error.localizedDescription))
			}
		}
	}

	private func sectionSelected(section: Show) {
		destination.send(.routeToDetail(section.show))
	}
}
