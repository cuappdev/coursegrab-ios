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

    private var popRecognizer: InteractivePopRecognizer?
    private let searchCellReuseId = "searchCellReuseId"
    private let searchHeaderReuseId = "searchHeaderReuseId"
    private var sections: [Section] = []
    private let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        sections = []

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: searchCellReuseId)
        tableView.register(SearchTableViewHeader.self, forHeaderFooterViewReuseIdentifier: searchHeaderReuseId)

        // Setup navigationBar
        textField.frame.size.width = view.frame.width - 80
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a course",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.5),
                .font: UIFont._20Medium
            ]
        )
        textField.font = ._20Medium

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

// MARK: - Datasource

extension SearchTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellReuseId, for: indexPath) as! SearchTableViewCell
        cell.configure(for: sections[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(SearchDetailTableViewController(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: searchHeaderReuseId) as! SearchTableViewHeader
        headerView.configure(numResults: sections.count)
        return headerView
    }
    
}


// MARK: - View lifecycle

extension SearchTableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        setupPopGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textField.resignFirstResponder()
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
