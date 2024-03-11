//
//  Loadable.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

enum Loadable<T: Hashable> {
	case loaded(T)
	case error(LocalizedError?)
	case loading
	case notRequested

	var value: T? {
		switch self {
		case .loaded(let value):
			return value
		case .error, .loading, .notRequested:
			return nil
		}
	}

	var loading: Bool {
		switch self {
		case .loading:
			return true
		case .error, .notRequested, .loaded:
			return false
		}
	}

	var error: LocalizedError? {
		switch self {
		case let .error(value):
			return value
		case .notRequested, .loading,.loaded:
			return nil
		}
	}
}
