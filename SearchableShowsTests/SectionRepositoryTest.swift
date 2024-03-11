//
//  SectionRepositoryTest.swift
//  SearchableShowsTests
//
//  Created by Farzaneh on 2024-03-11.
//

import XCTest
@testable import SearchableShows

final class MockHTTPRequestProtocol: HTTPRequestProtocol {

	var performHandler: ((_ request: URLRequest) async throws -> (Data, URLResponse))?

	func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {

		try await performHandler!(request)
	}
}

final class MockCacheManagerProtocol: CacheManagerProtocol {

	var storeHandler: ((URLRequest, _ response: URLResponse, _ data: Data, _ duration: TimeInterval) -> Void)?

	func store(forRequest request: URLRequest, response: URLResponse, data: Data, duration: TimeInterval) {

		storeHandler?(request,response,data,duration)
	}

	var responseHandler: ((_ request: URLRequest) -> (Data, URLResponse)?)?

	func response(forRequest request: URLRequest) -> (Data, URLResponse)? {
		responseHandler?(request)
	}
}

final class MockDataDecoderProtocol: DataDecoderProtocol {
	var decodeHandler: (() -> Data?)?

	func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
		if let response = decodeHandler?() {
			let decoder = JSONDecoder()
			return try decoder.decode(type, from: response)
		} else {
			fatalError("This method has not implemented")
		}
	}
}

final class RepositoryTest: XCTestCase {

	var mockHTTPRequestProtocolObject: MockHTTPRequestProtocol!
	var mockCacheManagerProtocolObject: MockCacheManagerProtocol!
	var mockDataDecoderProtocolObject: MockDataDecoderProtocol!

	override func setUp() {
		mockHTTPRequestProtocolObject = .init()
		mockCacheManagerProtocolObject = .init()
		mockDataDecoderProtocolObject = .init()
	}

	override func tearDown() {
		mockHTTPRequestProtocolObject = nil
		mockCacheManagerProtocolObject = nil
		mockDataDecoderProtocolObject = nil
	}

	func makeSUT() -> SectionRepository {
		SectionRepository(apiManager: mockHTTPRequestProtocolObject, cacheService: mockCacheManagerProtocolObject, decoder: mockDataDecoderProtocolObject)
	}

	func test_fetchSectionList_whenCacheServiceIsAvailableReturnDataFromCache() async throws {
		// Given
		let sut = makeSUT()
		let data = Show.jsonData
		var isDecoderCalled = false
		var isApiCalled = false
		let expectedEntity = try JSONDecoder().decode([Show].self, from: data!)

		mockDataDecoderProtocolObject.decodeHandler = {
			isDecoderCalled = true
			return data
		}

		mockHTTPRequestProtocolObject.performHandler = { _ in
			isApiCalled = true
			return (.init(), .init())
		}
		mockCacheManagerProtocolObject.responseHandler = { _ in
			let response = URLResponse()
			return (data!,response)
		}

		// When
		let value = try await sut.searchMovie(movieName: "")

		// Then
		XCTAssertEqual(value, expectedEntity)
		XCTAssertTrue(isDecoderCalled)
		XCTAssertFalse(isApiCalled)
	}

	func test_fetchSectionList_whenCacheServiceIsEmptyApiRetrieveData() async throws {
		// Given
		let sut = makeSUT()
		let data = Show.jsonData
		let queryName = "girls"
		var isDecoderCalled = false
		let expectedRequestURL = try MovieServiceEndPoint.searchMovie(queryName).createURLRequest().url!.absoluteString
		let expectedEntity = try JSONDecoder().decode([Show].self, from: data!)

		mockDataDecoderProtocolObject.decodeHandler = {
			isDecoderCalled = true
			return data
		}
		mockCacheManagerProtocolObject.responseHandler = { _ in
			return nil
		}

		mockCacheManagerProtocolObject.storeHandler = { request, response, _data, duration in
			XCTAssertEqual(expectedRequestURL, request.url!.absoluteString)
			XCTAssertEqual(_data, data)
			XCTAssertEqual(duration, SectionRepository.Constant.cacheTimeInterval)
		}

		mockHTTPRequestProtocolObject.performHandler = { request in
			return (data!, .init())
		}

		// When
		let value = try await sut.searchMovie(movieName: queryName)

		// Then
		XCTAssertEqual(value, expectedEntity)
		XCTAssertTrue(isDecoderCalled)
	}

	func test_fetchSectionList_whenCacheServiceIsEmptyApiThrowError() async throws {
		// Given
		let sut = makeSUT()
		let data = Show.jsonData
		var isDecoderCalled = false
		let apiError = NSError(domain: "Server", code: 500)
		var isCacheStoreCalled = false

		mockDataDecoderProtocolObject.decodeHandler = {
			isDecoderCalled = true
			return data
		}
		mockCacheManagerProtocolObject.responseHandler = { _ in
			return nil
		}

		mockCacheManagerProtocolObject.storeHandler = { request, response, _data, duration in
			isCacheStoreCalled = true
		}

		mockHTTPRequestProtocolObject.performHandler = { request in
			throw apiError
		}

		do {
			// When
			_ = try await sut.searchMovie(movieName: "")
			XCTFail("Should not be here")
		} catch {
			// Then
			XCTAssertEqual(error.localizedDescription, apiError.localizedDescription)
			XCTAssertFalse(isDecoderCalled)
			XCTAssertFalse(isCacheStoreCalled)
		}
	}
}
