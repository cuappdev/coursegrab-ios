//
//  SearchDetailTableViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "INFO 1998"
        tableView.separatorInset = .zero
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "icon_settings"),
            style: .plain,
            target: self,
            action: nil
        )
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchDetailTableViewCell()
        cell.configure(title: "LEC 001 / W 7:30PM", isOpen: Bool.random(), isTracked: Bool.random())
        return cell
    }

}
