//
//  SearchTableViewCell.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 2/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    private let arrowImageView = UIImageView()
    private let divider = UIView()
    private let containerView = UIView()
    private let statusBadge = UIImageView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let trackingButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup appearance

        selectionStyle = .none

        arrowImageView.backgroundColor = .black
        arrowImageView.contentMode = .scaleAspectFit
        containerView.addSubview(arrowImageView)

        divider.backgroundColor = .courseGrabBorder
        containerView.addSubview(divider)
        divider.isHidden = true

        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOffset = .zero
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)

        titleLabel.font = ._16Semibold
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)

        trackingButton.isHidden = true
        trackingButton.layer.cornerRadius = 2
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        trackingButton.titleLabel?.font = ._12Semibold
        trackingButton.setTitle("REMOVE", for: .normal)
        trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        containerView.addSubview(trackingButton)

        statusBadge.contentMode = .scaleAspectFit
        containerView.addSubview(statusBadge)
        statusBadge.isHidden = true

        subtitleLabel.font = ._14Semibold
        containerView.addSubview(subtitleLabel)
        subtitleLabel.isHidden = true

        // Setup constraints

        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
            make.top.bottom.leading.equalToSuperview().inset(16)
        }

    }

    func configure(for section: Section) {
        titleLabel.text = section.title

        if section.isTracking {
            divider.isHidden = false
            trackingButton.isHidden = false
            statusBadge.isHidden = false
            statusBadge.image = section.status.icon
            subtitleLabel.isHidden = false
            subtitleLabel.text = section.section

            titleLabel.snp.remakeConstraints { make in
                make.leading.top.equalToSuperview().inset(16)
                make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
                make.bottom.equalTo(divider.snp.top).offset(-11)
            }

            divider.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(1)
                make.top.equalTo(titleLabel.snp.bottom).offset(11)
                make.bottom.equalToSuperview().inset(44)
            }

            statusBadge.snp.makeConstraints { make in
                make.size.equalTo(16)
                make.leading.equalToSuperview().offset(16)
                make.top.equalTo(divider.snp.bottom).offset(12)
                make.bottom.equalToSuperview().inset(16)
            }

            subtitleLabel.snp.makeConstraints { make in
                make.leading.equalTo(statusBadge.snp.trailing).offset(12)
                make.centerY.equalTo(statusBadge.snp.centerY)
            }

            trackingButton.snp.makeConstraints { make in
                make.height.equalTo(24)
                make.width.equalTo(90)
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalTo(subtitleLabel.snp.centerY)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
