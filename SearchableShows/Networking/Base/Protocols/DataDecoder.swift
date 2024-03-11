//
//  DataDecoder.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol DataDecoderProtocol {
	func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: DataDecoderProtocol {}
