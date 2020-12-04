//
//  TrackingBannerView.swift
//  CourseGrab
//
//  Created by Haiying W on 12/1/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class TrackingBannerView: UIView {

    private let containerView = UIView()
    private let notificationLabel = UILabel()

    init(section: Section, isTracking: Bool) {
        super.init(frame: .zero)

        containerView.backgroundColor = .courseGrabWhite
        containerView.layer.cornerRadius = 5
        addSubview(containerView)

        notificationLabel.text = "You are \(isTracking ? "now" : "no longer") tracking \(section.subjectCode) \(section.courseNum) \(section.getSectionNum())"
        notificationLabel.font = ._12Bold
        notificationLabel.textAlignment = .center
        notificationLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(notificationLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        notificationLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
