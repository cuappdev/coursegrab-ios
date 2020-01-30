//
//  SearchDetailCardTableViewCell.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchDetailCardTableViewCell: UITableViewCell {

    private let cardView = UIView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCardView()
        setupSubtitleLabel()
        setupTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCardView() {
        cardView.layer.cornerRadius = 4
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.courseGrabBorder.cgColor
        cardView.backgroundColor = .white
        contentView.addSubview(cardView)

        cardView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(76)
            make.centerY.equalToSuperview()
        }
    }

    private func setupSubtitleLabel() {
        subtitleLabel.font = ._14Semibold
        subtitleLabel.textColor = .courseGrabGrey
        cardView.addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupTitleLabel() {
        titleLabel.font = ._16Semibold
        titleLabel.textColor = .black
        cardView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

}
