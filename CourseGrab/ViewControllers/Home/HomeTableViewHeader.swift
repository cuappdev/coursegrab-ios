//
//  HomeTableViewHeader.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class HomeTableViewHeader: UITableViewHeaderFooterView {

    private let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white

        titleLabel.font = ._20Semibold
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(6)
            make.top.equalToSuperview().inset(6)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for tableSection: HomeTableViewController.TableSection) {
        switch tableSection {
        case .available(let sections):
            titleLabel.text = "\(sections.count) Available"
            titleLabel.textColor = .courseGrabGreen
        case .awaiting(let sections):
            titleLabel.text = "\(sections.count) Awaiting"
            titleLabel.textColor = .black
        }
    }

}
