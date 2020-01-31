//
//  SearchDetailTableViewCell.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell {

    private var trackingButton = UIButton()
    private var statusView = UIView()
    private var titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupStatusView(status: .closed)
        setupTitleLabel()
        setupTrackingButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure

    func configure(section: Section) {
        titleLabel.text = section.section
        setupStatusView(status: section.status)

        if section.isTracking {
            trackingButton.setTitle("REMOVE", for: .normal)
            trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        } else {
            trackingButton.setTitle("TRACK", for: .normal)
            trackingButton.setTitleColor(.courseGrabBlack, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabBlack.cgColor
        }
    }

    // MARK - Private helpers

    private func setupStatusView(status: Status) {
        switch status {
        case .closed:
            statusView.backgroundColor = .courseGrabRuby
            statusView.layer.cornerRadius = 2
        case .open:
            statusView.backgroundColor = .courseGrabGreen
            statusView.layer.cornerRadius = 8
        case .waitlist:
            statusView.backgroundColor = .yellow
            statusView.layer.cornerRadius = 2
        }
        contentView.addSubview(statusView)

        statusView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTitleLabel() {
        titleLabel.font = ._14Semibold
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTrackingButton() {
        trackingButton.layer.cornerRadius = 2
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        trackingButton.titleLabel?.font = ._12Semibold
        contentView.addSubview(trackingButton)
        
        trackingButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(90)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }

}
