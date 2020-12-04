//
//  SearchDetailTableViewCell.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell {

    private let popularityImageView = UIImageView()
    private let popularityLabel = UILabel()
    private var section: Section?
    private let statusImageView = UIImageView()
    private let titleLabel = UILabel()
    private let trackingButton = UIButton(type: .roundedRect)

    var updateTracking: ((Section, Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup appearance

        selectionStyle = .none

        popularityImageView.image = UIImage.popularityIcon
        contentView.addSubview(popularityImageView)

        popularityLabel.font = ._12Medium
        popularityLabel.textColor = .courseGrabMediumGray
        contentView.addSubview(popularityLabel)

        contentView.addSubview(statusImageView)

        titleLabel.font = ._14Semibold
        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLabel)

        trackingButton.layer.cornerRadius = 2
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        trackingButton.titleLabel?.font = ._12Medium
        contentView.addSubview(trackingButton)

        // Setup constraints

        popularityImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.leading.equalTo(statusImageView.snp.trailing).offset(12)
            make.width.equalTo(16)
            make.height.equalTo(12)
        }

        popularityLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(popularityImageView.snp.trailing).offset(3)
        }

        statusImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
        }

        trackingButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(90)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusImageView.snp.trailing).offset(12)
            make.trailing.equalTo(trackingButton.snp.leading).offset(-12)
            make.top.equalToSuperview().offset(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure

    func configure(section: Section) {
        self.section = section

        popularityLabel.text = "\(section.numTracking) tracking"
        statusImageView.image = section.status.icon
        titleLabel.text = section.getSectionByTimezone()

        if section.isTracking {
            trackingButton.setTitle("REMOVE", for: .normal)
            trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
            trackingButton.on(.touchUpInside, untrackCourse)
        } else {
            trackingButton.setTitle("TRACK", for: .normal)
            trackingButton.setTitleColor(.courseGrabBlack, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabBlack.cgColor
            trackingButton.on(.touchUpInside, trackCourse)
        }
    }

    // MARK: - Private helpers

    private func trackCourse(_ button: UIButton) {
        guard let section = section else { return }
        updateTracking?(section, true)
    }

    private func untrackCourse(_ button: UIButton) {
        guard let section = section else { return }
        updateTracking?(section, false)
    }

}
