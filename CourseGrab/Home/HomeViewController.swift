//
//  HomeViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    private let cellReuseId = "cell"
    private var sections: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections.append(
            Section(
                catalogNum: 140,
                courseNum: 15821,
                section: "LEC 001 / TR 1:25PM",
                status: .open,
                subjectCode: "NBA",
                title: "NBA 3000: Designing New Ventures"
            )
        )

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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: cellReuseId)
    }

}

// MARK: - UITableViewDataSource

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! HomeTableViewCell
        cell.section = sections[indexPath.row]
        return cell
    }

}
