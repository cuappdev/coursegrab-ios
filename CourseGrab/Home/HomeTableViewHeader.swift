//
//  HomeTableViewHeader.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class HomeTableViewHeader: UITableViewHeaderFooterView {

    private let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white
        titleLabel.font = ._20Semibold
        contentView.addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(tableSection: HomeViewController.TableSection, section: Int) {
        switch tableSection {
        case .available(let sections):
            titleLabel.text = "\(sections.count) Available"
            titleLabel.textColor = .courseGrabGreen
        case .awaiting(let sections):
            titleLabel.text = "\(sections.count) Awaiting"
            titleLabel.textColor = .black
        }
        let topPadding = section == 0 ? 24 : 6
        titleLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(6)
            make.top.equalToSuperview().inset(topPadding)
        }
    }

}
