//
//  HomeViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit
import Tactile

class HomeViewController: UITableViewController {

    private let homeCellReuseId = "homeCellReuseId"
    private var sections: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        sections = [
            Section(
                catalogNum: 103,
                courseNum: 15821,
                isTracking: true,
                section: "LEC 001 / TR 1:25PM",
                status: .open,
                subjectCode: "NBA",
                title: "NBA 3000: Designing New Ventures"
            ),
            Section(
                catalogNum: 51,
                courseNum: 29424,
                isTracking: true,
                section: "DIS 005 / TR 1:25PM",
                status: .closed,
                subjectCode: "CS",
                title: "CS 2112: Data Structures and Algorithms, a Very Long Title"
            ),
            Section(
                catalogNum: 12,
                courseNum: 5010,
                isTracking: true,
                section: "LEC 002 / W 2:10PM",
                status: .waitlist,
                subjectCode: "PE",
                title: "Introductory Rock Climbing"
            )
        ]

        // Setup navigation bar
        let titleLabel = UILabel()
        titleLabel.text = "CourseGrab"
        titleLabel.textColor = .white
        titleLabel.font = ._20Semibold
        navigationItem.titleView = titleLabel

        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(.settingsIcon, for: .normal)
        settingsButton.on(.touchUpInside, showSettings)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)

        let searchButton = UIButton(type: .system)
        searchButton.setImage(.searchIcon, for: .normal)
        searchButton.on(.touchUpInside, showSearch)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)

        // Setup tableView
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellReuseId)
    }

}

// MARK: - UITableViewDataSource

extension HomeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellReuseId, for: indexPath) as! HomeTableViewCell
        cell.configure(for: sections[indexPath.row])
        return cell
    }

}

// MARK: - Show view controllers

extension HomeViewController {

    private func showSettings(_ button: UIButton) {
        present(SettingsViewController(), animated: false)
    }

    private func showSearch(_ button: UIButton) {
        // Grab navigation bar views and frames
        guard let navigationBar = navigationController?.navigationBar,
            let leftButton = navigationItem.leftBarButtonItem?.customView as? UIButton,
            let leftButtonFrame = leftButton.superview?.convert(leftButton.frame, to: navigationBar),
            let rightButton = navigationItem.rightBarButtonItem?.customView as? UIButton,
            let rightButtonFrame = rightButton.superview?.convert(rightButton.frame, to: navigationBar),
            let titleLabel = navigationItem.titleView as? UILabel,
            let titleLabelFrame = titleLabel.superview?.convert(titleLabel.frame, to: navigationBar)
            else { return }

        // Remove views from navigationBar
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = nil

        // Add views back to the navigationBar, but so that they aren't controlled by
        // autolayout and we can animate them.
        leftButton.frame = leftButtonFrame
        navigationBar.addSubview(leftButton)
        rightButton.frame = rightButtonFrame
        navigationBar.addSubview(rightButton)
        titleLabel.frame = titleLabelFrame
        navigationBar.addSubview(titleLabel)

        // Update the search button to look like a back button. We have to update the
        // frame because the images are not the same size.
        rightButton.setImage(.backIcon, for: .normal)
        rightButton.sizeToFit()
        rightButton.frame.origin.y = rightButtonFrame.origin.y + (rightButtonFrame.height - rightButton.frame.height) / 2

        // Create the textField and transform it so it is a little off from the final
        // destination. We will animate the transform away for a swiping effect.
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a course",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.5),
                .font: UIFont._20Medium
            ]
        )
        textField.textColor = .white
        textField.font = ._20Medium
        textField.alpha = 0
        navigationBar.addSubview(textField)
        textField.sizeToFit()
        textField.frame.origin.x = leftButton.frame.origin.x + rightButton.frame.width + 8
        textField.frame.size.width = view.frame.width - textField.frame.origin.x - 40
        textField.center.y = leftButton.center.y
        textField.transform = CGAffineTransform(translationX: 20, y: 0)

        // Perform the animations, where we hide the views we don't want anymore and
        // transform them to create the swiping effect.
        UIView.animate(withDuration: 0.3, animations: {
            leftButton.alpha = 0
            leftButton.transform = CGAffineTransform(translationX: -20, y: 0)

            rightButton.transform = CGAffineTransform(translationX: leftButtonFrame.origin.x - rightButtonFrame.origin.x, y: 0)

            titleLabel.alpha = 0
            titleLabel.transform = CGAffineTransform(translationX: -20, y: 0)

            textField.alpha = 1
            textField.transform = .identity
        }) { _ in
            // Remove the views from the navigationBar. We don't want them staying there!
            leftButton.removeFromSuperview()
            rightButton.removeFromSuperview()
            titleLabel.removeFromSuperview()
            textField.removeFromSuperview()

            // Remove the transform from the right button so it doesn't affect us when
            // we don't expect it.
            rightButton.transform = .identity
        }

        // Create and present the SearchViewController by fading it in.
        let searchViewController = SearchViewController()
        UIView.transition(from: view, to: searchViewController.view, duration: 0.3, options: .transitionCrossDissolve) { _ in
            self.navigationController?.pushViewController(searchViewController, animated: false)

            // Reset the navigationBar for when the user swipes back.
            leftButton.alpha = 1
            rightButton.setImage(.searchIcon, for: .normal)
            rightButton.sizeToFit()
            titleLabel.alpha = 1

            self.navigationItem.leftBarButtonItems = nil
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            self.navigationItem.titleView = titleLabel
        }
    }

}
