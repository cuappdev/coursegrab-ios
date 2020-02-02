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

        isUserInteractionEnabled = false
        setupCardView()
        setupSubtitleLabel()
        setupTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    // MARK: - Private helpers

    private func setupCardView() {
        cardView.layer.cornerRadius = 4
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.courseGrabBorder.cgColor
        cardView.backgroundColor = .white
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 4
        contentView.addSubview(cardView)

        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(76)
            make.centerY.equalToSuperview()
        }
    }

    private func setupSubtitleLabel() {
        subtitleLabel.font = ._14Semibold
        subtitleLabel.textColor = .courseGrabGray
        cardView.addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupTitleLabel() {
        titleLabel.font = ._16Semibold
        titleLabel.textColor = .black
        cardView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(16)
        }
    }

}
