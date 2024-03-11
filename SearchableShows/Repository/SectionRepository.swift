//
//  SectionRepository.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

final class SectionRepository: SectionUsecase {

	// Constants for caching time interval
	enum Constant {
		static let cacheTimeInterval: TimeInterval = 30 * 60
	}

	// Dependencies
	private let apiManager: HTTPRequestProtocol
	private let cacheService: CacheManagerProtocol
	private let decoder: DataDecoderProtocol

	// Initialize the repository with required dependencies
	init(
		apiManager: HTTPRequestProtocol,
		cacheService: CacheManagerProtocol,
		decoder: DataDecoderProtocol = JSONDecoder()
	) {
		self.apiManager = apiManager
		self.cacheService = cacheService
		self.decoder = decoder
	}

	func searchMovie(movieName: String) async throws -> [Show] {

		let request = MovieServiceEndPoint.searchMovie(movieName)
		let urlRequest = try request.createURLRequest()

		if let (data, _) = cacheService.response(forRequestProtocol: urlRequest) {
			return try decoder.decode([Show].self, from: data)
		}

		do {
			let (data, response) = try await apiManager.perform(urlRequest)
			// Store the response in the cache
			cacheService.store(forRequestProtocol: urlRequest, response: response, data: data, duration: Constant.cacheTimeInterval)
			return try decoder.decode([Show].self, from: data)
		} catch {
			throw error
		}
	}
}
