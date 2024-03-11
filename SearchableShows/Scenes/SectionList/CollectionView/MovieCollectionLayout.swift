//
//  MovieCollectionLayout.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation
import UIKit

protocol MovieCollectionViewLayoutProvider {
	func buildLayout() -> UICollectionViewLayout
}

final class MovieCollectionViewLayout: MovieCollectionViewLayoutProvider {
	func buildLayout() -> UICollectionViewLayout {
		return UICollectionViewCompositionalLayout { sectionIndex, _ in
			switch ListSection.allCases[sectionIndex] {

			case .movie:
				let item = NSCollectionLayoutItem(layoutSize: .init(
					widthDimension: .fractionalWidth(1 / 2),
					heightDimension: .fractionalHeight(1)))
				item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
				let group = NSCollectionLayoutGroup.horizontal(
					layoutSize: .init(
						widthDimension: .fractionalWidth(1),
						heightDimension: .estimated(50)),
					repeatingSubitem: item,
					count: 2
				)
				group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
				return NSCollectionLayoutSection(group: group)
			}
		}
	}
}
