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

    private let course: Course

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
        return indexPath.section == 0 ? 110 : 42
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
            cell.configure(title: course.title, subtitle: "KEVIN CHAN") // TODO: Get PROF name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.section.rawValue) as! SearchDetailTableViewCell
            cell.configure(section: course.sections[indexPath.row])
            return cell
        }
    }

}
