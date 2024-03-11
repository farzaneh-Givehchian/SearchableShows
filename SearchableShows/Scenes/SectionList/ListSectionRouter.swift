//
//  ListSectionRouter.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation

protocol SectionListRouterProtocol: AnyObject {
	var viewController: SectionListViewController? { get set }
	func routeToSectionDetail(movie: MovieModel)
}

class SectionListRouter: SectionListRouterProtocol {
	weak var viewController: SectionListViewController?
	var sectionUsecase: SectionUsecase?

	init(sectionUsecase: SectionUsecase? = nil) {
		self.sectionUsecase = sectionUsecase
	}

	func routeToSectionDetail(movie: MovieModel) {

		guard let sectionUsecase = sectionUsecase else {
			fatalError("Route to detail can't be done - sectionUsecase is nil ")
		}

		let destination = ContentViewController.init(viewModel: ContentViewModel(movie: movie, repository: sectionUsecase))
		self.viewController?.navigationController?.pushViewController(destination, animated: true)
	}
}
