//
//  HomeViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import DifferenceKit
import SkeletonView
import SPPermissions
import Tactile
import UIKit

class HomeViewController: UIViewController {

    /// Describes the state of the entire view controller
    private enum State {
        case normal, loading, empty, error
    }

    /// A section in the table
    enum TableSection {
        case available([Section]), awaiting([Section])
    }

    private let homeCellReuseId = "homeCellReuseId"
    private let homeHeaderReuseId = "homeHeaderReuseId"
    private var tableSections: [TableSection] = []
    private var tableView = UITableView(frame: .zero, style: .grouped)

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
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeTableViewHeader.self, forHeaderFooterViewReuseIdentifier: homeHeaderReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isSkeletonable = true
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellReuseId)
        tableView.showAnimatedSkeleton()

        if !UserDefaults.standard.didPromptPermission {
            displayPermissionModal()
        }

        show(state: .loading)
    }

    override func viewDidAppear(_ animated: Bool) {
        getAllTrackedCourses()
    }

    private func displayPermissionModal() {
        let controller = SPPermissions.dialog([.notification])
        controller.titleText = "Get In Your Courses"
        controller.footerText = "Push notifications enhance the CourseGrab experience."
        controller.dataSource = self
        controller.delegate = self
        controller.present(on: self)
    }

}

// MARK: - Networking

extension HomeViewController {

    private func getAllTrackedCourses() {
        NetworkManager.shared.getAllTrackedCourses().observe { result in
            switch result {
            case .value(let response):
                // Section identifiers
                let availableModel = "available"
                let awaitingModel = "awaiting"

                // Construct source array
                let currentAvailable = self.availableSections()
                let currentAwaiting = self.awaitingSections()
                var source: [ArraySection<String, Section>] = []
                if currentAvailable.count > 0 {
                    source.append(ArraySection(model: availableModel, elements: currentAvailable))
                }
                if currentAwaiting.count > 0 {
                    source.append(ArraySection(model: awaitingModel, elements: currentAwaiting))
                }

                // Construct target array
                let available = response.data.filter { $0.status == .open }
                let awaiting = response.data.filter { $0.status != .open }
                var target: [ArraySection<String, Section>] = []
                if available.count > 0 {
                    target.append(ArraySection(model: availableModel, elements: available))
                }
                if awaiting.count > 0 {
                    target.append(ArraySection(model: awaitingModel, elements: awaiting))
                }

                // Get change set
                let changeSet = StagedChangeset(source: source, target: target)

                // Apply updates to UI
                DispatchQueue.main.async {
                    // Update state if needed
                    if available.count == 0 && awaiting.count == 0 {
                        self.show(state: .empty)
                    } else {
                        self.show(state: .normal)
                    }

                    // Tell DifferenceKit to handle reloading the table
//                    self.tableView.reload(using: changeSet, with: .fade) { data in
//                        var newTableSections: [TableSection] = []
//                        // Add the available table section only if there are available sections
//                        if let newAvailable = data.first(where: { $0.model == availableModel })?.elements, newAvailable.count > 0 {
//                            newTableSections.append(.available(newAvailable))
//                        }
//                        // Add the awaiting table section only if there are awaiting sections
//                        if let newAwaiting = data.first(where: { $0.model == awaitingModel })?.elements, newAwaiting.count > 0 {
//                            newTableSections.append(.awaiting(newAwaiting))
//                        }
//                        // Update model
//                        self.tableSections = newTableSections
//                    }
                }
            case .error:
                DispatchQueue.main.async {
                    self.show(state: .error)
                }
            }
        }
    }

    /// Gets the available sections currently stored locally in the model
    private func availableSections() -> [Section] {
        if let index = index(of: .available([])),
            case .available(let sections) = tableSections[index] {
            return sections
        }
        return []
    }

    /// Gets the awaiting sections currently stored locally in the model
    private func awaitingSections() -> [Section] {
        if let index = index(of: .awaiting([])),
            case .awaiting(let sections) = tableSections[index] {
            return sections
        }
        return []
    }

    /// Gets the index of a table section or `nil` if it is not in the local model.
    private func index(of tableSection: TableSection) -> Int? {
        for (i, section) in tableSections.enumerated() {
            switch (tableSection, section) {
            case (.awaiting, .awaiting), (.available, .available):
                return i
            default:
                continue
            }
        }
        return nil
    }

    /// Updates the table to reflect the given state.
    private func show(state: State) {
        switch state {
        case .normal:
            tableView.backgroundView = nil
            break
        case .empty:
            // tableView.backgroundView = HomeStateView(title: "No Courses Currently Tracked", subtitle: "Tap the search icon to start adding courses", icon: Status.open.icon)
            break
        case .loading:
            // tableView.backgroundView = nil
            break
        case .error:
            // tableView.backgroundView = HomeStateView(title: "No Internet Connection", subtitle: "Please try again later", icon: Status.closed.icon)
            break
        }
    }

}

// MARK: - SPPermissionsDataSource

extension HomeViewController: SPPermissionsDataSource {

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

// MARK: - UITableViewDelegate

extension HomeViewController: SkeletonTableViewDelegate {

}

// MARK: - UITableViewDataSource

extension HomeViewController: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableSections.count == 0 {
            return 1
        }

        switch tableSections[section] {
        case .available(let sections), .awaiting(let sections):
            return sections.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count == 0 ? 1 : tableSections.count
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: homeHeaderReuseId) as! HomeTableViewHeader
        // headerView.configure(for: tableSections[section])
        return headerView
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        homeCellReuseId
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableSections.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeCellReuseId, for: indexPath) as! HomeTableViewCell
            // cell.isSkeletonable = true
            // cell.showAnimatedSkeleton()
            return cell
        }

        switch tableSections[indexPath.section] {
        case .available(let sections), .awaiting(let sections):
            let cell = tableView.dequeueReusableCell(withIdentifier: homeCellReuseId, for: indexPath) as! HomeTableViewCell
            cell.configure(for: sections[indexPath.row])
            cell.untrackSection = untrack(section:)
            return cell
        }
    }

}

// MARK: Untrack section

extension HomeViewController {

    /// Describes a change to the model that occurs during a call to `removeSectionFromModel`.
    private enum UpdateDataChange {
        case removedSection(Int), removedRow(IndexPath), none
    }

    private func untrack(section: Section) {
        NetworkManager.shared.untrackCourse(catalogNum: section.catalogNum).observe { result in
            switch result {
            case .value(let response):
                guard response.success else { return }
                let change = self.removeSectionFromModel(response.data)
                DispatchQueue.main.async {
                    switch change {
                    case .removedRow(let indexPath):
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .removedSection(let section):
                        self.tableView.deleteSections([section], with: .automatic)
                        if self.tableSections.count == 0 {
                            self.show(state: .empty)
                        }
                    case .none:
                        break
                    }
                }
            case .error(let error):
                print(error)
            }
        }
    }

    /// Removes a section from the model and returns the change, if any.
    private func removeSectionFromModel(_ section: Section) -> UpdateDataChange {
        for (i, tableSection) in tableSections.enumerated() {
            switch tableSection {
            case .available(var sections):
                if let j = sections.firstIndex(where: { $0.catalogNum == section.catalogNum }) {
                    sections.remove(at: j)
                    if sections.count > 0 {
                        tableSections[i] = .available(sections)
                        return .removedRow(IndexPath(row: j, section: i))
                    } else {
                        tableSections.remove(at: i)
                        return .removedSection(i)
                    }
                }
            case .awaiting(var sections):
                if let j = sections.firstIndex(where: { $0.catalogNum == section.catalogNum }) {
                    sections.remove(at: j)
                    if sections.count > 0 {
                        tableSections[i] = .awaiting(sections)
                        return .removedRow(IndexPath(row: j, section: i))
                    } else {
                        tableSections.remove(at: i)
                        return .removedSection(i)
                    }
                }
            }
        }

        return .none
    }

}

// MARK: - SPPermissionsDelegate

extension HomeViewController: SPPermissionsDelegate {

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

// MARK: - Show view controllers

extension HomeViewController {

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
        }, completion: { _ in
            // Remove the views from the navigationBar. We don't want them staying there!
            leftButton.removeFromSuperview()
            rightButton.removeFromSuperview()
            titleLabel.removeFromSuperview()
            textField.removeFromSuperview()

            // Remove the transform from the right button so it doesn't affect us when
            // we don't expect it.
            rightButton.transform = .identity
        })

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
