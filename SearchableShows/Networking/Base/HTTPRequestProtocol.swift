//
//  HTTPRequestProtocol.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol HTTPRequestProtocol {
	func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse)
}

final class HTTPRequestExecuter: HTTPRequestProtocol {
	private let network: NetworkService

	init(network: NetworkService = URLSession.shared) {
		self.network = network
	}

	func perform(_ urlRequest: URLRequest) async throws -> (data: Data, response: URLResponse) {

		do {
			let (data, response) = try await network.data(for: urlRequest)

			guard let httpResponse = response as? HTTPURLResponse,
						200 ... 299 ~= httpResponse.statusCode
			else {
				throw NetworkError.invalidServerResponse(data)
			}
			return (data, response)
		} catch {
			throw error
		}
	}
}
