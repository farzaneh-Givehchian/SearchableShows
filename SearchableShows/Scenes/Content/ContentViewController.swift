//
//  ContentViewController.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Combine
import Foundation
import UIKit

final class ContentViewController: UIViewController {

	// MARK: - Variables

	private let viewModel: any ContentViewModelProtocol
	private var cancellables: Set<AnyCancellable> = .init()

	// MARK: - UI Components

	lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.numberOfLines = 0
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Initialization

	init(viewModel: any ContentViewModelProtocol) {
		self.viewModel =  viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("This view controller doesn't support storyboards")
	}

	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		prepareUI()
	}

	// MARK: - Prepare UI

	func prepareUI() {

		view.backgroundColor = UIColor.white
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
		self.title = viewModel.title

		let data = viewModel.description.data(using: .utf8)!

		let attributedString = try? NSAttributedString(
			data: data,
			options: [.documentType: NSAttributedString.DocumentType.html],
			documentAttributes: nil)

		descriptionLabel.attributedText = attributedString

		// add subviews
		self.view.addSubview(descriptionLabel)

		setConstraints()
	}

	// MARK: - Constraints

	func setConstraints() {
		let constraints = [
			descriptionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 4),
			descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4),
			descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4)
		]

		NSLayoutConstraint.activate(constraints)
	}
}
