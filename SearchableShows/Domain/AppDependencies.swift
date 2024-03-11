//
//  AppDependencies.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol Dependencies {
	var sectionUsecase: SectionUsecase { get }
}

class AppDependencies: Dependencies {

	lazy var sectionUsecase: SectionUsecase = SectionRepository(
		apiManager: HTTPRequestExecuter(),
		cacheService: CacheManager(
			urlCache: .shared
		)
	)
}
