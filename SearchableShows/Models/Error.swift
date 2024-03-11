//
//  Error.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

struct AppError: Error, LocalizedError {

	let reason: String?

	var errorDescription: String? {
		reason ?? "unknownError"
	}
}

enum NetworkError: Error {
	case badURL
	case invalidJSON
	case serverError
	case noResponse
	case unauthorized
	case generalError
	case decodeFailed
	case notFound
	case invalidServerResponse(Data)
}
