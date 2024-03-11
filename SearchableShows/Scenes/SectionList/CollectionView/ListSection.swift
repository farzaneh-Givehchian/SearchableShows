//
//  ListSection.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation
import UIKit

enum ListSection: Int, Identifiable, Hashable, CaseIterable {
	var id: Int { rawValue }
	case movie
}

enum ListSectionItem: Identifiable, Hashable {

	var id: String {
		switch self {
		case let .movie(value):
			return value.id
		}
	}

	case movie(MovieBannerConfiguration)

	var configuration: UIContentConfiguration {
		switch self {
		case let .movie(value):
			return value
		}
	}
}
