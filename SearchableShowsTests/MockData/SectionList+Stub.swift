//
//  SectionList+Stub.swift
//  SearchableShowsTests
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation
@testable import SearchableShows

extension Show {
	static var jsonString: String {
"""
[
	{
	 "score":0.91296417,
	 "show":{
		 "id":139,
		 "url":"https://www.tvmaze.com/shows/139/girls",
		 "name":"Girls",
		 "type":"Scripted",
		 "language":"English",
		 "genres":[
			"Drama",
			"Romance"
		 ],
		 "status":"Ended",
		 "runtime":30,
		 "averageRuntime":30,
		 "premiered":"2012-04-15",
		 "ended":"2017-04-16",
		 "officialSite":"http://www.hbo.com/girls",
		 "schedule":{
			"time":"22:00",
			"days":[
				"Sunday"
			]
		 },
		 "rating":{
			"average":6.5
		 },
		 "weight":95,
		 "network":{
			"id":8,
			"name":"HBO",
			"country":{
				"name":"United States",
				"code":"US",
				"timezone":"America/New_York"
			},
			"officialSite":"https://www.hbo.com/"
		 },
		 "webChannel":null,
		 "dvdCountry":null,
		 "externals":{
			"tvrage":30124,
			"thetvdb":220411,
			"imdb":"tt1723816"
		 },
		 "image":{
			"medium":"https://static.tvmaze.com/uploads/images/medium_portrait/31/78286.jpg",
			"original":"https://static.tvmaze.com/uploads/images/original_untouched/31/78286.jpg"
		 },
		 "summary":"<p>This Emmy winning series is a comic look at the assorted humiliations and rare triumphs of a group of girls in their 20s.</p>",
		 "updated":1704794122,
		 "_links":{
			"self":{
				"href":"https://api.tvmaze.com/shows/139"
			},
			"previousepisode":{
				"href":"https://api.tvmaze.com/episodes/1079686"
			}
		 }
	 }
	}
]
"""
	}

	static var jsonData: Data? {
		jsonString.data(using: .utf8)
	}

	static func stub() -> Self {
		if let jsonData = jsonData {
			do {
				let movieContainer = try JSONDecoder().decode([Show].self, from: jsonData)
				return movieContainer.first!
			} catch {
				return .init(show: .init(id: 0, url: "", name: "", summary: "", type: ""), score: 0)
			}
		} else {
			return .init(show: .init(id: 0, url: "", name: "", summary: "", type: ""), score: 0)
		}
	}
}
