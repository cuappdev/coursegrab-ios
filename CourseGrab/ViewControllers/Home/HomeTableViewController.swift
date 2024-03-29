//
//  HomeTableViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import DZNEmptyDataSet
import Reachability
import SPPermissions
import Tactile
import UIKit

class HomeTableViewController: UITableViewController {

    /// Describes the state of the entire view controller
    private enum State {
        case empty, error, loading, noConnection, normal
    }

    /// A section in the table
    enum TableSection {
        case available([Section]), awaiting([Section])
    }

    private let homeCellReuseId = "homeCellReuseId"
    private let homeHeaderReuseId = "homeHeaderReuseId"
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let reachability = try! Reachability()
    private var state: State = .loading
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
        tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeTableViewHeader.self, forHeaderFooterViewReuseIdentifier: homeHeaderReuseId)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellReuseId)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        refreshControl = UIRefreshControl()
        refreshControl?.on(.valueChanged, refreshTableView)

        if !UserDefaults.standard.didPromptPermission {
            displayPermissionModal()
        } else {
            // Present announcement if there are any new ones to present
            // TODO: Add logging here for when we successfully present an announcement
            presentAnnouncement(completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        getAllTrackedCourses()
        AppDevAnalytics.shared.logFirebase(NumberOfTrackedSectionsPayload(numberOfSections: tableSections.count))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @objc func refreshTableView(_ sender: Any) {
        getAllTrackedCourses()
    }

    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            getAllTrackedCourses()
        case .unavailable, .none:
            state = .noConnection
            tableView.reloadEmptyDataSet()
        }
    }

}

// MARK: - Networking

extension HomeTableViewController {

    private func getAllTrackedCourses() {
        refreshControl?.endRefreshing()
        impactFeedbackGenerator.prepare()

        NetworkManager.shared.getAllTrackedSections().observe { result in
            switch result {
            case .value(let response):
                
                let available = response.data.sections.filter { $0.status == .open }
                let awaiting = response.data.sections.filter { $0.status != .open }
                var sections = [TableSection]()
                
                if available.count > 0 {
                    sections.append(.available(available))
                }
                
                if awaiting.count > 0 {
                    sections.append(.awaiting(awaiting))
                }
              
                DispatchQueue.main.async {
                    if available.count == 0 && awaiting.count == 0 {
                        self.state = .empty
                    } else {
                        self.state = .normal
                    }
                    
                    self.tableSections = sections
                    
                    self.tableView.reloadData()
                    self.tableView.reloadEmptyDataSet()
                    self.reloadSectionHeaders()
                }
            case .error:
                DispatchQueue.main.async {
                    self.state = .error
                    self.tableView.reloadEmptyDataSet()
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

    private func displayPermissionModal() {
        let controller = SPPermissions.dialog([.notification])
        controller.titleText = "Get In Your Courses"
        controller.footerText = "Push notifications enhance the CourseGrab experience."
        controller.dataSource = self
        controller.delegate = self
        controller.present(on: self)
    }

    func didAllow(permission: SPPermission) {
        UserDefaults.standard.didPromptPermission = true
        UIApplication.shared.registerForRemoteNotifications()
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
        tableSections.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: homeHeaderReuseId) as! HomeTableViewHeader
        headerView.configure(for: tableSections[section])
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeTableViewCell
        cell.isHighlighted = true
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeTableViewCell
        cell.isHighlighted = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableSections[indexPath.section] {
        case .available(let sections), .awaiting(let sections):
            NetworkManager.shared.getCourse(courseNum: sections[indexPath.row].courseId).observe { result in
                switch result {
                case .value(let response):
                    guard response.success else { return }
                    let courseDetailViewController = SearchDetailTableViewController(course: response.data)
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(courseDetailViewController, animated: true)
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
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
            cell.configure(for: sections[indexPath.row])
            cell.untrackSection = untrack(section:)
            return cell
        }
    }

    private func reloadSectionHeaders() {
        for (i, tableSection) in tableSections.enumerated() {
            if let header = tableView.headerView(forSection: i) as? HomeTableViewHeader {
                header.configure(for: tableSection)
            }
        }
    }

}

// MARK: Untrack section

extension HomeTableViewController {

    /// Describes a change to the model that occurs during a call to `removeSectionFromModel`.
    private enum UpdateDataChange {
        case removedSection(Int), removedRow(IndexPath), none
    }

    private func untrack(section: Section) {
        impactFeedbackGenerator.impactOccurred()
        NetworkManager.shared.untrackSection(catalogNum: section.catalogNum).observe { result in
            switch result {
            case .value(let response):
                guard response.success else { return }
                let change = self.removeSectionFromModel(response.data)
                let description = "\(section.subjectCode) \(section.courseNum): \(section.title) - \(section.section)"
                AppDevAnalytics.shared.logFirebase(UntrackSectionPayload(courseTitle: description, catalogNum: section.catalogNum))
                DispatchQueue.main.async {
                    switch change {
                    case .removedRow(let indexPath):
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .removedSection(let section):
                        self.tableView.deleteSections([section], with: .automatic)
                        if self.tableSections.count == 0 {
                            self.state = .empty
                            self.tableView.reloadEmptyDataSet()
                        }
                    case .none:
                        break
                    }
                    self.reloadSectionHeaders()
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

// MARK: - Show view controllers

extension HomeTableViewController {

    private func showSettings(_ button: UIButton) {
        let settingsViewController = SettingsViewController()
        settingsViewController.updateHomeTableViewTimezones = { () -> Void in
            self.tableView.reloadData()
        }
        
        present(settingsViewController, animated: true)
    }

    private func showSearch(_ button: UIButton) {
        AppDevAnalytics.shared.logFirebase(SearchIconPressPayload())

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
        UIView.animate(withDuration: 0.2, animations: {
            leftButton.alpha = 0
            leftButton.transform = CGAffineTransform(translationX: -20, y: 0)

            rightButton.transform = CGAffineTransform(translationX: leftButtonFrame.origin.x - rightButtonFrame.origin.x, y: 0)

            titleLabel.alpha = 0
            titleLabel.transform = CGAffineTransform(translationX: -20, y: 0)

            textField.alpha = 1
            textField.transform = .identity
        },
        completion: { _ in
//             Remove the views from the navigationBar. We don't want them staying there!
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
        UIView.transition(from: view, to: searchViewController.view, duration: 0.2, options: .transitionCrossDissolve) { _ in
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

// MARK: - DZNEmptyDataSet

extension HomeTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        switch state {
        case .normal:
            return UIView()
        case .empty:
            // Reset content offset to avoid refresh control to stay after pull to refresh
            tableView.setContentOffset(.zero, animated: false)
            return HomeStateView(title: "No Courses Currently Tracked",
                                 subtitle: "Tap the search icon to start adding courses",
                                 icon: Status.open.icon)
        case .loading:
            tableView.setContentOffset(.zero, animated: false)
            return HomeStateView(title: "Loading...",
                                 subtitle: "Fetching your courses",
                                 icon: UIImage())
        case .error:
            return HomeStateView(title: "Could Not Connect to Server",
                                 subtitle: "Pull down to refresh",
                                 icon: Status.closed.icon)
        case .noConnection:
            return HomeStateView(title: "No Internet Connection",
                                 subtitle: "Pull down to refresh",
                                 icon: Status.closed.icon)
        }
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -tableView.frame.size.height / 4
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return state != .empty && state != .loading
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
