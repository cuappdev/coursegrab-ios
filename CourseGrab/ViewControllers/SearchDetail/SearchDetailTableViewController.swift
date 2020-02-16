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

    let section = Section(catalogNum: 1234, courseNum: 1998, isTracking: true, section: "LEC 001", status: .open, subjectCode: "INFO", title: "Intro to Digital Product Design")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(section.subjectCode) \(section.courseNum)"
        tableView.separatorInset = .zero

        tableView.register(SearchDetailCardTableViewCell.self, forCellReuseIdentifier: CellIdentifier.card.rawValue)
        tableView.register(SearchDetailTableViewCell.self, forCellReuseIdentifier: CellIdentifier.section.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 110 : 42
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.card.rawValue) as! SearchDetailCardTableViewCell
            cell.configure(title: section.title, subtitle: "KEVIN CHAN")
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.section.rawValue) as! SearchDetailTableViewCell
        cell.configure(section: section)
        return cell
    }

}
