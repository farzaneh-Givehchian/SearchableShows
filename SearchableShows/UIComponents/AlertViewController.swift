//
//  AlertViewController.swift
//  SearchableShows
//
//  Created by Farzaneh on 2024-03-11.
//

import Foundation
import UIKit

class AlertPresenter {

	static func showErrorAlert(on viewController: UIViewController, message: LocalizedError?, completionHandler: (() -> Void)? = nil) {
		let alert = UIAlertController(title: "Error", message: message?.errorDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
			completionHandler?()
		}))
		viewController.present(alert, animated: true, completion: nil)
	}
}
