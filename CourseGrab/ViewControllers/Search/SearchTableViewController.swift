//
//  SearchTableViewController.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/3/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import Tactile
import UIKit

class SearchTableViewController: UITableViewController {

    private var courses: [Course] = []
    private var lastSearchTimestamp = Timestamp()
    private var popRecognizer: InteractivePopRecognizer?
    private let searchCellReuseId = "searchCellReuseId"
    private let searchHeaderReuseId = "searchHeaderReuseId"
    private let textField = UITextField()
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: searchCellReuseId)
        tableView.register(SearchTableViewHeader.self, forHeaderFooterViewReuseIdentifier: searchHeaderReuseId)

        // Setup navigationBar
        textField.frame.size.width = view.frame.width - 80
        textField.on(.editingChanged, textDidChange)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a course",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.5),
                .font: UIFont._20Medium
            ]
        )
        textField.font = ._20Medium
        textField.autocorrectionType = .no

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

// MARK: - Networking

extension SearchTableViewController {
    
    @objc private func getCourses(timer: Timer) {
        if let userInfo = timer.userInfo as? [String: String],
            let searchText = userInfo["searchText"] {
            NetworkManager.shared.searchCourse(query: searchText).observe { result in
                switch result {
                case .value(let response):
                    DispatchQueue.main.async {
                        if response.timestamp >= self.lastSearchTimestamp {
                            self.lastSearchTimestamp = response.timestamp
                            self.courses = response.data
                            self.tableView.reloadData()
                        }
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }

    private func textDidChange(_ textField: UITextField) {
        guard let searchText = textField.text, searchText.count > 2 else {
            if courses.count > 0 {
                DispatchQueue.main.async {
                    self.courses.removeAll()
                    self.tableView.reloadData()
                }
            }
            return
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.2,
            target: self,
            selector: #selector(getCourses),
            userInfo: ["searchText": searchText],
            repeats: false
        )
    }

}

// MARK: - Datasource

extension SearchTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellReuseId, for: indexPath) as! SearchTableViewCell
        cell.configure(for: courses[indexPath.row])
        cell.untrackSection = untrack(section:)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: searchHeaderReuseId) as! SearchTableViewHeader
        headerView.configure(numResults: courses.count)
        return headerView
    }
    
}

// MARK: - Delegate

extension SearchTableViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(SearchDetailTableViewController(course: courses[indexPath.row]), animated: true)
    }

    private func untrack(section: Section) {
        NetworkManager.shared.untrackCourse(catalogNum: section.catalogNum).observe { result in
            switch result {
            case .value(let response):
                guard response.success, self.updateData(newSection: response.data) != nil else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .error(let error):
                print(error)
            }
        }
    }

    /// Updates the model and returns the index path in the table to update, if any.
    private func updateData(newSection section: Section) -> IndexPath? {
        guard let courseIndex = courses.firstIndex(where: { $0.courseNum == section.courseNum }),
            let sectionIndex = courses[courseIndex].sections.firstIndex(where: { $0.catalogNum == section.catalogNum }) else {
            return nil
        }

        let oldCourse = courses[courseIndex]

        var sections = oldCourse.sections
        sections[sectionIndex] = section

        let newCourse = Course(
            courseNum: oldCourse.courseNum,
            subjectCode: oldCourse.subjectCode,
            sections: sections,
            title: oldCourse.title
        )

        courses[courseIndex] = newCourse

        return IndexPath(row: courseIndex, section: 0)
    }

}

// MARK: - View lifecycle

extension SearchTableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        setupPopGesture()
        tableView.isScrollEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
        textDidChange(textField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textField.resignFirstResponder()
        tableView.isScrollEnabled = false
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
