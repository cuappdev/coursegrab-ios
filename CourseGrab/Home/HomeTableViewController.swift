//
//  HomeTableViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SPPermissions
import Tactile
import UIKit

class HomeTableViewController: UITableViewController {

    enum TableSection {
        case available([Section]), awaiting([Section])
    }

    private let homeCellReuseId = "homeCellReuseId"
    private let homeHeaderReuseId = "homeHeaderReuseId"
    private var tableSections: [TableSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeTableViewHeader.self, forHeaderFooterViewReuseIdentifier: homeHeaderReuseId)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellReuseId)

        if (!UserDefaults.standard.didPromptPermission) {
            displayPermissionModal()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableSections = []
            self.tableView.reloadData()
            self.getAllTrackedCourses()
        }
    }

    func displayPermissionModal() {
        let controller = SPPermissions.dialog([.notification])
        controller.titleText = "Get In Your Courses"
        controller.footerText = "Push notifications enhance the CourseGrab experience."
        controller.dataSource = self
        controller.delegate = self
        controller.present(on: self)
    }

}

// MARK: - Networking

extension HomeTableViewController {

    private func getAllTrackedCourses() {
        NetworkManager.shared.getAllTrackedCourses().observe { result in
            switch result {
            case .value(let response):
                let available = response.data.filter { $0.status == .open }
                if !available.isEmpty {
                    self.tableSections.append(.available(available))
                }
                let awaiting = response.data.filter { $0.status != .open }
                if !awaiting.isEmpty {
                    self.tableSections.append(.awaiting(awaiting))
                }
                var newSections: IndexSet = []
                (0..<self.tableSections.count).forEach { newSections.insert($0) }
                if newSections.count > 0 {
                    DispatchQueue.main.async {
                        self.tableView.backgroundView = nil
                        self.tableView.insertSections(newSections, with: .automatic)
                    }
                } else {
                    self.showEmptyState()
                }
            case .error(let error):
                print(error)
                self.showErrorState()
            }
        }
    }

    private func showEmptyState() {
        DispatchQueue.main.async {
            self.tableView.backgroundView = HomeErrorView(frame: .zero, title: "No Courses Currently Tracked", subtitle: "Tap the search icon to start adding courses", icon: Status.open.icon)
        }
    }

    private func showErrorState() {
        DispatchQueue.main.async {
            self.tableView.backgroundView = HomeErrorView(frame: .zero, title: "No Internet Connection", subtitle: "Tap the search icon to start adding courses", icon: Status.closed.icon)
        }
    }

}

// MARK: - SPPermissionsDataSource

extension HomeTableViewController: SPPermissionsDataSource {

    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        cell.permissionTitleLabel.text = "Notifications"
        cell.permissionDescriptionLabel.text = "We'll tell you when a section opens!"
        cell.iconView.color = .courseGrabGreen
        cell.button.allowTitle = "Allow"
        cell.button.allowedTitle = "Allowed"
        cell.button.allowedBackgroundColor = .courseGrabGreen
        cell.button.allowBackgroundColor = .courseGrabGreen
        cell.button.allowTitleColor = .white
        return cell
    }
    
}

// MARK: - SPPermissionsDelegate

extension HomeTableViewController: SPPermissionsDelegate {

    func didAllow(permission: SPPermission) {
        UserDefaults.standard.didPromptPermission = true
    }

    func didDenied(permission: SPPermission) {
        UserDefaults.standard.didPromptPermission = true
    }

    func didHide(permissions ids: [Int]) {
        UserDefaults.standard.didPromptPermission = true
    }

    func deniedData(for permission: SPPermission) -> SPPermissionDeniedAlertData? {
        if permission == .notification {
            let data = SPPermissionDeniedAlertData()
            data.alertOpenSettingsDeniedPermissionTitle = "Permission denied"
            data.alertOpenSettingsDeniedPermissionDescription = "If you would like to receive push notifications for your courses, go to settings."
            data.alertOpenSettingsDeniedPermissionButtonTitle = "Settings"
            data.alertOpenSettingsDeniedPermissionCancelTitle = "Cancel"
            return data
        } else {
            // If returned nil, alert will not show.
            return nil
        }
    }
    
}

// MARK: - UITableViewDataSource

extension HomeTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: homeHeaderReuseId) as! HomeTableViewHeader
        headerView.configure(tableSection: tableSections[section], section: section)
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableSections[section] {
        case .available(let sections), .awaiting(let sections):
            return sections.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableSections[indexPath.section] {
        case .available(let sections), .awaiting(let sections):
            let cell = tableView.dequeueReusableCell(withIdentifier: homeCellReuseId, for: indexPath) as! HomeTableViewCell
            cell.delegate = self
            cell.configure(for: sections[indexPath.row])
            return cell
        }
    }

}

// MARK: - Show view controllers

extension HomeTableViewController {

    private func showSettings(_ button: UIButton) {
        present(SettingsViewController(), animated: true)
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
        let searchViewController = SearchTableViewController()
        searchViewController.view.frame = view.frame
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

extension HomeTableViewController: HomeTableViewCellDelegate {

    func homeTableViewCellDidUnenroll() {
        DispatchQueue.main.async {
            self.tableSections = []
            self.getAllTrackedCourses()
            self.tableView.reloadData()
        }
    }

}
