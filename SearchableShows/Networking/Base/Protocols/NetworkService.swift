//
//  NetworkService.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol NetworkService {
	func data(for url: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkService {}
