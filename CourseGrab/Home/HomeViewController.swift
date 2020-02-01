//
//  HomeViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

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

        view.backgroundColor = .white
        title = "CourseGrab"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "icon_settings"),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "icon_search"),
            style: .plain,
            target: self,
            action: nil
        )

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
