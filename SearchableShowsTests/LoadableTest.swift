//
//  LoadableTest.swift
//  SearchableShowsTests
//
//  Created by Farzaneh on 2024-03-11.
//

import XCTest
@testable import SearchableShows

final class LoadableTests: XCTestCase {

	func test_loadable_whenItsLoading() throws {
		var sut = Loadable<String>.notRequested
		sut = .loading
		XCTAssertTrue(sut.loading)
		XCTAssertNil(sut.value)
		XCTAssertNil(sut.error)
	}

	func test_loadable_whenDataLoaded() throws {
		var sut = Loadable<String>.notRequested
		sut = .loaded("test")
		XCTAssertFalse(sut.loading)
		XCTAssertEqual(sut.value, "test")
		XCTAssertNil(sut.error)
	}

	func test_loadable_inErrorState() throws {
		enum TestError: LocalizedError {
			case test
		}
		let error = TestError.test
		var sut = Loadable<String>.notRequested
		sut = .error(error)
		XCTAssertFalse(sut.loading)
		XCTAssertNil(sut.value)
		XCTAssertNotNil(sut.error)
	}
}
