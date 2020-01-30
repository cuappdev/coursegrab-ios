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
        sections.append(
            Section(
                catalogNum: 224,
                courseNum: 6006,
                section: "LAB 409 / W 2:30PM",
                status: .open,
                subjectCode: "PHY",
                title: "INFO 1998: Intro to Digital Product Design"
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
        
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        tableView.separatorStyle = .none
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

// MARK: - UITableViewDelegate

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.text = "2 Available"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .courseGrabGreen
        
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(headerView)
            make.bottom.equalTo(headerView).inset(4)
            make.left.equalTo(headerView).offset(26)
        }
        
        return headerView
    }
    
}
