//
//  MovieServiceEndPoint.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

enum MovieServiceEndPoint {
	case searchMovie(String)
}

extension MovieServiceEndPoint: EndPointTarget {

	var scheme: String { "https" }

	var host: String {
		"api.tvmaze.com"
	}

	var path: String {
		switch self {
		case .searchMovie:
			return "/search/shows"
		}
	}

	var params: [String: Any] {
		[:]
	}

	var headers: [String: String] {
		[:]
	}

	var cacheExpireTime: TimeInterval? {
		return nil
	}

	var requestType: HTTPMethod {
		switch self {
		case .searchMovie:
			return .get
		}
	}

	var urlParams: [String : String?] {
		switch self {
		case .searchMovie(let param):
			return ["q":param]
		}
	}
}
