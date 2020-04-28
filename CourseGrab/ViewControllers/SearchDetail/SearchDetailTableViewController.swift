//
//  SearchDetailTableViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController {

    private enum CellIdentifier: String {
        case card, section
    }

    private var course: Course
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    init(course: Course) {
        self.course = course
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(course.subjectCode) \(course.courseNum)"
        tableView.separatorInset = .zero
        tableView.register(SearchDetailCardTableViewCell.self, forCellReuseIdentifier: CellIdentifier.card.rawValue)
        tableView.register(SearchDetailTableViewCell.self, forCellReuseIdentifier: CellIdentifier.section.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isScrollEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.isScrollEnabled = false
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 42
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : course.sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.card.rawValue) as! SearchDetailCardTableViewCell
            cell.configure(title: "\(course.subjectCode) \(course.courseNum): \(course.title)", subtitle: course.instructors.joined(separator: ", "))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.section.rawValue) as! SearchDetailTableViewCell
            cell.configure(section: course.sections[indexPath.row])
            cell.updateTracking = updateTracking
            return cell
        }
    }

}

extension SearchDetailTableViewController {

    private func updateTracking(section: Section, track: Bool) {
        impactFeedbackGenerator.impactOccurred()
        if track {
            NetworkManager.shared.trackSection(catalogNum: section.catalogNum).observe { result in
                switch result {
                case .value(let response):
                    guard response.success, let indexPath = self.updateData(newSection: response.data) else { return }
                    let description = "\(section.subjectCode) \(section.courseNum): \(section.title) - \(section.section)"
                    AppDevAnalytics.shared.logFirebase(UntrackSectionPayload(courseTitle: description, catalogNum: section.catalogNum))
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                case .error(let error):
                    print(error)
                }
            }
        } else {
            NetworkManager.shared.untrackSection(catalogNum: section.catalogNum).observe { result in
                switch result {
                case .value(let response):
                    let description = "\(section.subjectCode) \(section.courseNum): \(section.title) - \(section.section)"
                    AppDevAnalytics.shared.logFirebase(UntrackSectionPayload(courseTitle: description, catalogNum: section.catalogNum))
                    guard response.success, let indexPath = self.updateData(newSection: response.data) else { return }
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }

    /// Updates the model and returns the index path in the table to update, if any.
    private func updateData(newSection section: Section) -> IndexPath? {
        var sections = course.sections

        guard let index = sections.firstIndex(where: { $0.catalogNum == section.catalogNum }) else {
            return nil
        }

        sections[index] = section

        course = Course(
            courseNum: course.courseNum,
            subjectCode: course.subjectCode,
            sections: sections,
            title: course.title
        )

        return IndexPath(row: index, section: 1)
    }

}
