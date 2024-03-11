//
//  CacheManager.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol CacheManagerProtocol {
	func store(forRequest request: URLRequest, response: URLResponse, data: Data, duration: TimeInterval)
	func response(forRequest request: URLRequest) -> (Data, URLResponse)?
}

extension CacheManagerProtocol {
	func response(forRequestProtocol urlRequest: URLRequest) -> (Data, URLResponse)? {
		return self.response(forRequest: urlRequest)
	}

	func store(forRequestProtocol urlRequest: URLRequest, response: URLResponse, data: Data, duration: TimeInterval) {
		return self.store(forRequest: urlRequest, response: response, data: data, duration: duration)
	}
}

final class CacheManager: CacheManagerProtocol {
	private let expire_key = "Expiry_Key"
	private let cache: URLCache

	init(urlCache: URLCache) {
		self.cache = urlCache
	}

	func store(forRequest request: URLRequest, response: URLResponse, data: Data, duration: TimeInterval) {
		let cachedResponse = CachedURLResponse(response: response, data: data)
		var userInfo = [AnyHashable: Any]()
		if let cachedUserInfo = cachedResponse.userInfo {
			userInfo = cachedUserInfo
		}
		let expireTime = Date().addingTimeInterval(duration).timeIntervalSince1970
		userInfo[expire_key] = expireTime
		cache.storeCachedResponse(.init(response: cachedResponse.response, data: data, userInfo: userInfo, storagePolicy: .allowed), for: request)
	}

	func response(forRequest request: URLRequest) -> (Data, URLResponse)? {
		guard let cacheResponse = cache.cachedResponse(for: request) else { return nil }
		guard let cacheDate = cacheResponse.userInfo?[expire_key] as? TimeInterval,
					Date(timeIntervalSince1970: cacheDate) > Date() else {
			return nil
		}
		return (cacheResponse.data, cacheResponse.response)
	}
}
