//
//  SearchDetailCardTableViewCell.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchDetailCardTableViewCell: UITableViewCell {

    private let containerView = UIView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup appearance

        isUserInteractionEnabled = false
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.courseGrabBorder.cgColor
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)

        subtitleLabel.font = ._14Semibold
        subtitleLabel.textColor = .courseGrabGray
        containerView.addSubview(subtitleLabel)

        titleLabel.font = ._16Semibold
        titleLabel.textColor = .black
        containerView.addSubview(titleLabel)

        // Setup constraints

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(76)
            make.centerY.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

}
