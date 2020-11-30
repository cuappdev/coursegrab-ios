//
//  SearchTableViewController.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/3/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import DZNEmptyDataSet
import Foundation
import Tactile
import UIKit

class SearchTableViewController: UITableViewController {

    private var courses: [Course] = []
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
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
        tableView.emptyDataSetSource = self

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
                        if response.data.query == self.textField.text,
                            response.timestamp >= self.lastSearchTimestamp {
                            self.lastSearchTimestamp = response.timestamp
                            self.courses = response.data.courses
                            self.tableView.reloadData()
                        }
                        AppDevAnalytics.shared.logFirebase(SearchedQueryPayload(query: searchText))
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
                courses.removeAll()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.reloadEmptyDataSet()
            }
            timer?.invalidate()
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
        courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellReuseId, for: indexPath) as! SearchTableViewCell
        cell.configure(for: courses[indexPath.row])
        cell.untrackSection = untrack(section:)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if 1...2 ~= textField.text?.count ?? 0 {
            return UIView()
        }
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
        let course = courses[indexPath.row]
        let description = "\(course.subjectCode) \(course.courseNum): \(course.title)"
        AppDevAnalytics.shared.logFirebase(CourseDetailPressPayload(courseTitle: description))
        navigationController?.pushViewController(SearchDetailTableViewController(course: course), animated: true)
    }

    private func untrack(section: Section) {
        impactFeedbackGenerator.impactOccurred()
        NetworkManager.shared.untrackSection(catalogNum: section.catalogNum).observe { result in
            switch result {
            case .value(let response):
                let description = "\(section.subjectCode) \(section.courseNum): \(section.title) - \(section.section)"
                AppDevAnalytics.shared.logFirebase(UntrackSectionPayload(courseTitle: description, catalogNum: section.catalogNum))
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

// MARK: - DZNEmptyDataSet

extension SearchTableViewController: DZNEmptyDataSetSource {

    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if 1...2 ~= textField.text?.count ?? 0 {
            return HomeStateView(title: "3 characters needed",
                                 subtitle: "Please add more",
                                 icon: Status.waitlist.icon)
        } else {
            return UIView()
        }
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -tableView.frame.size.height / 4
    }

}
