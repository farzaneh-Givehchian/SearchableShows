//
//  MovieServiceEndPointTest.swift
//  SearchableShowsTests
//
//  Created by Farzaneh on 2024-03-11.
//

import XCTest
@testable import SearchableShows

final class MovieServiceEndPointTest: XCTestCase {

	var sut: MovieServiceEndPoint!

	func test_section_list_endpoint() throws {
		let endpoint = "https://api.tvmaze.com/search/shows?q=girl"
		sut = .searchMovie("girl")
		let request = try sut.createURLRequest()
		let url = request.url?.absoluteString
		XCTAssertEqual(url, endpoint)
	}

	func test_section_list_http_method() throws {
		sut = .searchMovie("girl")
		XCTAssertEqual(sut.requestType, HTTPMethod.get)
	}
}
