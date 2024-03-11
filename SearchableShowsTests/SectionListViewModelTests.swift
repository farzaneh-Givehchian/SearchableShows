//
//  SectionListViewModelTests.swift
//  SearchableShowsTests
//
//  Created by Farzaneh on 2024-03-11.
//

import XCTest
@testable import SearchableShows
import Combine

final class MockSectionUseCase: SectionUsecase {

	var searchMovieHandler: ((_ movieName: String) async throws -> [SearchableShows.Show])?
	func searchMovie(movieName: String) async throws -> [SearchableShows.Show] {
		try await searchMovieHandler!(movieName)
	}
}

final class SectionListViewModelTests: XCTestCase {
	var mockSectionUseCase: MockSectionUseCase!
	var cancellable: Set<AnyCancellable>!

	override func setUpWithError() throws {
		mockSectionUseCase = .init()
		cancellable = .init()
	}

	override func tearDownWithError() throws {
		mockSectionUseCase = nil
		cancellable = nil
	}

	func makeSUT() -> SectionListViewModel {
		.init(sectionUsecase: mockSectionUseCase)
	}

	func test_fetchSections_whenUseCaseThrowError() async {
		// Given
		let expectation = self.expectation(description: #function.description)
		let sut = makeSUT()
		let apiError = NSError(domain: "Server error", code: 500)
		mockSectionUseCase.searchMovieHandler = { _ in
			throw apiError
		}

		// When
		var result: Error?
		sut.dataSourcePublisher.sink { state in
			switch state {
			case .loaded:
				XCTFail("Should not be loaded")
			case let .error(error):
				result = error
				expectation.fulfill()
			default:
				break
			}
		}.store(in: &cancellable)

		sut.searchMovies(movieName: "girls")

		// Then
		await fulfillment(of: [expectation], timeout: 0.5)
		XCTAssertEqual(result?.localizedDescription, AppError(reason: apiError.localizedDescription).localizedDescription)
	}

	func test_fetchSections_whenUseCaseRetrieveData() async {
		// Given
		let expectation = self.expectation(description: #function.description)
		let sut = makeSUT()
		let mockModel = Show.stub()
		mockSectionUseCase.searchMovieHandler = { _ in
			[mockModel]
		}

		// When
		let expectedData: [ListSection : [ListSectionItem]] = [
			.movie: [
				ListSectionItem.movie(.init(section: mockModel, tapAction: {}))
			]
		]
		var result: [ListSection : [ListSectionItem]]?
		sut.dataSourcePublisher.sink { state in
			switch state {
			case let .loaded(value):
				result = value
				expectation.fulfill()
			case .error:
				XCTFail("Should not be loaded")
			default:
				break
			}
		}.store(in: &cancellable)

		sut.searchMovies(movieName: "girls")

		// Then
		await fulfillment(of: [expectation], timeout: 0.5)
		XCTAssertEqual(result, expectedData)
	}

	func test_destination_whenItemTapActionCalled() async {
		// Given
		let expectation = self.expectation(description: #function.description)
		let sut = makeSUT()
		let mockModel = Show.stub()

		mockSectionUseCase.searchMovieHandler = { _ in
			[mockModel]
		}

		// When
		var result: MovieModel?
		sut.destinationPublisher.sink { destination in
			switch destination {
			case let .routeToDetail(link):
				result = link
				expectation.fulfill()
			}
		}.store(in: &cancellable)

		sut.dataSourcePublisher.sink { state in
			switch state {
			case let .loaded(value):
				value.values.forEach { list in
					list.forEach {
						if let item = $0.configuration as? MovieBannerConfiguration {
							item.tapAction()
						}
					}
				}
			case .error:
				XCTFail("Should not be loaded")
			default:
				break
			}
		}.store(in: &cancellable)

		sut.searchMovies(movieName: "girls")

		// Then
		await fulfillment(of: [expectation], timeout: 0.5)
		XCTAssertEqual(result, mockModel.show)
	}
}
