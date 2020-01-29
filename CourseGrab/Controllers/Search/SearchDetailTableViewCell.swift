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

        statusView.backgroundColor = .red
        statusView.layer.cornerRadius = 2
        contentView.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(statusView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }

        trackingButton.layer.cornerRadius = 2
        trackingButton.backgroundColor = .blue
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

        if isTracked {
            trackingButton.setTitle("REMOVE", for: .normal)
            trackingButton.titleLabel?.textColor = .red
            trackingButton.layer.borderColor = UIColor.red.cgColor
        } else {
            trackingButton.setTitle("TRACK", for: .normal)
            trackingButton.layer.borderColor = UIColor.black.cgColor
        }
    }

}
