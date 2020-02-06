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
    private let container = UIView()
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup appearance

        selectionStyle = .none

        //arrowImageView.image = UIImage(named: "logo_AppDev_black")
        arrowImageView.backgroundColor = .black
        arrowImageView.contentMode = .scaleAspectFit
        container.addSubview(arrowImageView)

        container.clipsToBounds = false
        container.layer.cornerRadius = 5
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowRadius = 2
        container.layer.shadowOffset = .zero
        container.backgroundColor = .white
        contentView.addSubview(container)

        titleLabel.font = ._16Semibold
        titleLabel.numberOfLines = 0
        container.addSubview(titleLabel)

        // Setup constraints

        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalTo(titleLabel.snp.trailing).inset(8)
            make.trailing.equalToSuperview().inset(16)
        }

        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(-8)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }

    func configure(for section: Section) {
        titleLabel.text = section.title

        if section.isTracking {
            // Setup appearance

            let divider = UIView()
            divider.backgroundColor = .courseGrabDivider
            container.addSubview(divider)

            let trackingButton = UIButton()
            trackingButton.layer.cornerRadius = 2
            trackingButton.layer.borderWidth = 1
            trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
            trackingButton.titleLabel?.font = ._12Semibold
            container.addSubview(trackingButton)
            trackingButton.setTitle("REMOVE", for: .normal)
            trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
            
            let statusBadge = UIImageView()
            statusBadge.contentMode = .scaleAspectFit
            statusBadge.image = section.status.icon
            container.addSubview(statusBadge)

            let subtitleLabel = UILabel()
            subtitleLabel.text = section.section
            subtitleLabel.font = ._14Semibold
            container.addSubview(subtitleLabel)

            // Setup constraints

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

            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.trailing.equalTo(arrowImageView.snp.leading).inset(-8)
                make.top.equalToSuperview().inset(16)
                make.bottom.equalTo(divider.snp.top).offset(-11)
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
