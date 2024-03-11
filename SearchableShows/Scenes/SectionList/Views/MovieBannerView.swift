//
//  MovieBannerView.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation
import UIKit

final class MovieBannerView: UIView, UIContentView {

	var configuration: UIContentConfiguration {
		didSet {
			updateConfiguration()
		}
	}

	lazy var containerView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 8
		view.clipsToBounds = true
		view.backgroundColor = UIColor.bannerBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.font = UIFont.boldSystemFont(ofSize: 14.0)
		label.backgroundColor = .clear
		label.alpha = 0.7
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	init(configuration: UIContentConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		setupViews()
		updateConfiguration()
	}

	required init?(coder: NSCoder) {

		self.configuration = MovieBannerConfiguration.init(section: .init(show: .init(id: 0, url: "", name: "", summary: "", type: ""), score: 0), tapAction: {})
		super.init(coder: coder)
		setupViews()
		updateConfiguration()
	}

	private func setupViews() {

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		containerView.addGestureRecognizer(tapGesture)

		self.addSubview(containerView)
		containerView.addSubview(titleLabel)

		let containerViewConstraints = [
			containerView.topAnchor.constraint(equalTo: self.topAnchor),
			containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		]
		NSLayoutConstraint.activate(containerViewConstraints)

		let titleConstraints = [
			titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
		]
		NSLayoutConstraint.activate(titleConstraints)
	}

	private func updateConfiguration() {
		guard let configuration = configuration as? MovieBannerConfiguration else { return }

		titleLabel.text = configuration.section.show.name
	}

	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		guard let configuration = configuration as? MovieBannerConfiguration else { return }
		configuration.tapAction()
	}
}

struct MovieBannerConfiguration: UIContentConfiguration, Hashable, Identifiable {

	var id: String {
		"\(section.show.id)"
	}

	let section: Show
	let tapAction: () -> Void

	init(section: Show, tapAction: @escaping () -> Void) {
		self.section = section
		self.tapAction = tapAction
	}

	static func == (lhs: MovieBannerConfiguration, rhs: MovieBannerConfiguration) -> Bool {
		lhs.section.show == rhs.section.show
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(section.show)
	}

	func makeContentView() -> UIView & UIContentView {
		MovieBannerView(configuration: self)
	}

	func updated(for state: UIConfigurationState) -> MovieBannerConfiguration {
		self
	}
}

