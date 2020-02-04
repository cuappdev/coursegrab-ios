//
//  SearchViewController.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/3/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import Tactile

class SearchViewController: UIViewController {

    private var popRecognizer: InteractivePopRecognizer?
    private let textField = UITextField()

    override func viewDidLoad() {
        view.backgroundColor = .white

        // Setup navigationBar
        
        textField.frame.size.width = view.frame.width - 80
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a course",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.5),
                .font: UIFont._20Medium
            ]
        )

        let backButton = UIButton(type: .system)
        backButton.setImage(.backIcon, for: .normal)
        backButton.on(.touchUpInside, back)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: backButton),
            UIBarButtonItem(customView: textField)
        ]
    }

}


// MARK: - View lifecycle

extension SearchViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        setupPopGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textField.resignFirstResponder()
    }

    private func back(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupPopGesture() {
        guard let navigationController = navigationController, popRecognizer == nil else { return }
        popRecognizer = InteractivePopRecognizer(navigationController: navigationController)
        navigationController.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
}
