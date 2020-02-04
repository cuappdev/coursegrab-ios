//
//  SearchViewController.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/3/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    private var popRecognizer: InteractivePopRecognizer?

    override func viewDidLoad() {
        view.backgroundColor = .white

        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a course",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.5),
                .font: UIFont._20Medium
            ]
        )

        let backButton = UIButton(type: .system)
        backButton.setImage(.backIcon, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: backButton),
            UIBarButtonItem(customView: textField)
        ]

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(banana)))
    }

    @objc func banana() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
        vc.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(banana)))
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = navigationController else { return }
        popRecognizer = InteractivePopRecognizer(controller: navigationController)
        navigationController.interactivePopGestureRecognizer?.delegate = popRecognizer
    }

    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

}
