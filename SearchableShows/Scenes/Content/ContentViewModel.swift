//
//  ContentViewModel.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Combine
import Foundation

protocol ContentViewModelProtocol {
	var title: String { get }
	var description: String { get }
}

final class ContentViewModel: ContentViewModelProtocol {

	private let repository: SectionUsecase
	private var movie: MovieModel
	var title: String
	var description: String

	init(
		movie: MovieModel,
		repository: SectionUsecase
	) {
		self.repository = repository
		self.movie = movie
		self.title = movie.name
		self.description = movie.summary ?? "\(movie.name) | \(movie.type)"
	}
}
