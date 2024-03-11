//
//  CollectionDataSource.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation
import UIKit

protocol CollectionDataSourceProtocol {
	init(collectionView: UICollectionView)
	func update(with data: [ListSection: [ListSectionItem]])
}

extension ListSectionItem {
	static let movieReuseId = "MovieView"

	var reuseIdentifier: String {
		switch self {
		case .movie:
			return Self.movieReuseId
		}
	}
}

final class MovieCollectionDataSource: UICollectionViewDiffableDataSource<ListSection, ListSectionItem>, CollectionDataSourceProtocol {

	convenience init(collectionView: UICollectionView) {

		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ListSectionItem.movieReuseId)

		self.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier.reuseIdentifier, for: indexPath)
			cell.contentConfiguration = itemIdentifier.configuration
			return cell
		}
	}

	func update(with data: [ListSection: [ListSectionItem]]) {
		var snapshot = NSDiffableDataSourceSnapshot<ListSection, ListSectionItem>()
		snapshot.appendSections(ListSection.allCases)
		for (key, values) in data {
			snapshot.appendItems(values, toSection: key)
		}
		apply(snapshot, animatingDifferences: true)
	}
}
