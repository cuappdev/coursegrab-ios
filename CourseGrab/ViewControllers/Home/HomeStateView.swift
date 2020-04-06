//
//  HomeStateView.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 3/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class HomeStateView: UIView {

    private let imageView = UIImageView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()

    init(title: String, subtitle: String, icon: UIImage) {
        super.init(frame: .zero)
        backgroundColor = .white

        imageView.image = icon
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        titleLabel.font = ._20Medium
        titleLabel.textColor = .black
        titleLabel.text = title
        addSubview(titleLabel)

        subtitleLabel.font = ._18Medium
        subtitleLabel.textColor = .courseGrabLightGray
        subtitleLabel.text = subtitle
        addSubview(subtitleLabel)


        imageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(198)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
