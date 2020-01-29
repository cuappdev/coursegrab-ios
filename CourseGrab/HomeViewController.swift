//
//  HomeViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

}

// MARK: - UITableViewDataSource

extension HomeViewController {

}
