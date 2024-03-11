//
//  SectionUsecase.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol SectionUsecase {
	func searchMovie(movieName: String) async throws -> [Show]
}
