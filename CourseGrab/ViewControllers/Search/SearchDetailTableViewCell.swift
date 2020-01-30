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

        setupStatusView(isOpen: false)
        setuptitleLabel()
        setupTrackingbutton()
    }

    private func setupStatusView(isOpen: Bool) {
        if isOpen {
            statusView.backgroundColor = .courseGrabGreen
            statusView.layer.cornerRadius = 8
        } else {
            statusView.backgroundColor = .courseGrabRuby
            statusView.layer.cornerRadius = 2
        }
        contentView.addSubview(statusView)

        statusView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }

    private func setuptitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = ._14Semibold

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(statusView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTrackingbutton() {
        trackingButton.layer.cornerRadius = 2
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        trackingButton.titleLabel?.font = ._12Semibold
        contentView.addSubview(trackingButton)
        
        trackingButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(90)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isOpen: Bool, isTracked: Bool) {
        titleLabel.text = title

        setupStatusView(isOpen: isOpen)

        if isTracked {
            trackingButton.setTitle("REMOVE", for: .normal)
            trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        } else {
            trackingButton.setTitle("TRACK", for: .normal)
            trackingButton.setTitleColor(.black, for: .normal)
            trackingButton.layer.borderColor = UIColor.black.cgColor
        }
    }

}
