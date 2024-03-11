//
//  MovieResponseModel.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation
struct Show: Decodable, Hashable {
	var score: Double
	var show: MovieModel

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		score = try container.decode(Double.self, forKey: .score)
		show = try container.decode(MovieModel.self, forKey: .show)
	}

	enum CodingKeys: String, CodingKey {
		case score
		case show
	}

	init(show: MovieModel, score: Double) {
		self.show = show
		self.score = score
	}

}

struct MovieModel: Decodable, Hashable, Identifiable {
	let id: Int
	let url: String
	let name: String
	let summary: String?
	let type: String

	enum CodingKeys: String, CodingKey {
		case id, url, name, type, summary

	}
}
