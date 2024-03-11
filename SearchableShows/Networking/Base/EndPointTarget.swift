//
//  EndPointTarget.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol EndPointTarget {
	var host: String { get }
	var path: String { get }
	var headers: [String: String] { get }
	var params: [String: Any] { get }
	var urlParams: [String: String?] { get }
	var scheme: String { get }
	var requestType: HTTPMethod { get }
	var cacheExpireTime: TimeInterval? { get }
	func createURLRequest() throws -> URLRequest
}

enum HTTPMethod: String {
	case get = "GET"
}

extension EndPointTarget {
	func createURLRequest() throws -> URLRequest {
		var components = URLComponents()
		components.scheme = scheme
		components.host = host
		components.path = path

		if !urlParams.isEmpty {
			components.queryItems = urlParams.map {
				URLQueryItem(name: $0, value: $1)
			}
		}

		guard let url = components.url
		else { throw NetworkError.badURL }

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = requestType.rawValue

		if !headers.isEmpty {
			urlRequest.allHTTPHeaderFields = headers
		}

		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

		if !params.isEmpty {
			urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
		}
		return urlRequest
	}
}
