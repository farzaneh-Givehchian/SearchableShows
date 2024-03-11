//
//  SearchableShows.swift
//  SearchableShowsTests
//
//  Created by Farzaneh on 2024-03-11.
//

import XCTest
@testable import SearchableShows

final class NetworkServiceMock: NetworkService {

	var dataHandler: ((_ url: URLRequest) async throws -> (Data, URLResponse))?
	func data(for url: URLRequest) async throws -> (Data, URLResponse) {
		try await dataHandler!(url)
	}
}

final class NetworkExecuterTest: XCTestCase {

	var sut: HTTPRequestExecuter!
	var mock: NetworkServiceMock!

	func makeSUT() -> HTTPRequestExecuter {
		.init(network: mock)
	}

	override func setUpWithError() throws {
		mock = NetworkServiceMock()
	}

	override func tearDownWithError() throws {
		mock = nil
	}

	func test_perform_SuccessfulRequest() async {

		//Given
		let url = URL.init(string: "https://example.com")!
		let urlRequest = URLRequest(url: url)
		let testData = "Error data".data(using: .utf8)!

		mock.dataHandler = { _ in
			let mockResponse: URLResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
			return (testData, mockResponse)
		}

		do {
			//When
			let result = try await mock.data(for: urlRequest)
			//Then
			XCTAssertEqual(testData, result.0)
		} catch {
			XCTFail("Unexpected error: \(error)")
		}
	}

	func test_perform_RequestFailureWithServerResponse() async {

		//Given
		let url = URL.init(string: "https://example.com")!
		let urlRequest = URLRequest(url: url)
		let testData = "Error data".data(using: .utf8)!

		mock.dataHandler = { _ in
			let mockResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!

			return (testData, mockResponse)
		}

		do {
			//When
			let _ = try await mock.data(for: urlRequest)

		} catch {
			//Then
			guard case NetworkError.invalidServerResponse(let data) = error else {
				XCTFail("Unexpected error type: \(error)")
				return
			}
			XCTAssertEqual(data, testData)
		}
	}

	func test_perform_RequestFailureWithNetworkError() async {

		//Given
		let apiError = NSError(domain: "Server", code: 500)
		let urlRequest = URLRequest(url: .init(string: "https://example.com")!)

		mock.dataHandler = { _ in
			throw apiError
		}

		do {
			//When
			_ = try await mock.data(for: urlRequest)
			XCTFail("Should not be here")
		} catch {
			//Then
			XCTAssertEqual(error.localizedDescription,apiError.localizedDescription )
		}
	}
}

