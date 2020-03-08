//
//  SearchDetailTableViewCell.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell {

    private var section: Section!
    private let statusView = UIView()
    private let titleLabel = UILabel()
    private let trackingButton = UIButton(type: .roundedRect)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup appearance

        selectionStyle = .none
        setupStatusView(status: .closed)

        titleLabel.font = ._14Semibold
        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLabel)

        trackingButton.layer.cornerRadius = 2
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        trackingButton.titleLabel?.font = ._12Medium
        contentView.addSubview(trackingButton)

        // Setup constraints

        trackingButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(90)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusView.snp.trailing).offset(12)
            make.trailing.equalTo(trackingButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure

    func configure(section: Section) {
        self.section = section
        titleLabel.text = section.section
        setupStatusView(status: section.status)

        if section.isTracking {
            trackingButton.setTitle("REMOVE", for: .normal)
            trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
            trackingButton.on(.touchUpInside, removeCourse)
        } else {
            trackingButton.setTitle("TRACK", for: .normal)
            trackingButton.setTitleColor(.courseGrabBlack, for: .normal)
            trackingButton.layer.borderColor = UIColor.courseGrabBlack.cgColor
            trackingButton.on(.touchUpInside, trackCourse)
        }
    }

    // MARK: - Private helpers

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

    private func trackCourse(_ button: UIButton) {

        NetworkManager.shared.trackCourse(catalogNum: section.catalogNum).observe { result in
            switch result {
            case .value(let response):
                print(response)
                DispatchQueue.main.async {
                    self.trackingButton.setTitle("REMOVE", for: .normal)
                    self.trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
                    self.trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
                    self.trackingButton.on(.touchUpInside, self.removeCourse)
                }
            case .error(let error):
                print(error)
            }
        }
    }

    private func removeCourse(_ button: UIButton) {
        NetworkManager.shared.untrackCourse(catalogNum: section.catalogNum).observe { result in
            switch result {
            case .value(let response):
                print(response)
                DispatchQueue.main.async {
                    self.trackingButton.setTitle("TRACK", for: .normal)
                    self.trackingButton.setTitleColor(.courseGrabBlack, for: .normal)
                    self.trackingButton.layer.borderColor = UIColor.courseGrabBlack.cgColor
                    self.trackingButton.on(.touchUpInside, self.trackCourse)
                }
                break
            case .error(let error):
                break
            }
        }
    }

}
