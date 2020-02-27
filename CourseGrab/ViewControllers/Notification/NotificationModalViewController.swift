//
//  NotificationModalViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 2/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Tactile
import UIKit

class NotificationModalViewController: UIViewController {

    private let availableLabel = UILabel()
    private let courseIDLabel = UILabel()
    private let courseIDStackView = UIStackView()
    private let courseIDTitleLabel = UILabel()
    private let courseTitleLabel = UILabel()
    private let homeButton = UIButton()
    private let sectionLabel = UILabel()
    private let studentCenterButton = UIButton()

    private let section = Section(
        catalogNum: 51,
        courseNum: 29424,
        isTracking: true,
        section: "DIS 005 / TR 1:25PM",
        status: .open,
        subjectCode: "CS",
        title: "CS 2112: Data Structures and Algorithms, a Very Long Title"
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup appearance
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .black

        availableLabel.text = "AVAILABLE NOW"
        availableLabel.textAlignment = .center
        availableLabel.adjustsFontSizeToFitWidth = true
        availableLabel.font = ._24Bold
        availableLabel.textColor = .courseGrabGreen
        view.addSubview(availableLabel)

        courseTitleLabel.text = section.title.uppercased()
        courseTitleLabel.textAlignment = .center
        courseTitleLabel.adjustsFontSizeToFitWidth = true
        courseTitleLabel.numberOfLines = 2
        courseTitleLabel.font = ._24Bold
        courseTitleLabel.textColor = .white
        view.addSubview(courseTitleLabel)

        sectionLabel.text = section.section.uppercased()
        sectionLabel.textAlignment = .center
        sectionLabel.adjustsFontSizeToFitWidth = true
        sectionLabel.font = ._20Semibold
        sectionLabel.textColor = .white
        view.addSubview(sectionLabel)

        courseIDStackView.spacing = 8
        courseIDStackView.axis = .vertical
        view.addSubview(courseIDStackView)

        courseIDTitleLabel.text = "COURSE ID"
        courseIDTitleLabel.textAlignment = .center
        courseIDTitleLabel.adjustsFontSizeToFitWidth = true
        courseIDTitleLabel.font = ._16Bold
        courseIDTitleLabel.textColor = .courseGrabBorder
        courseIDStackView.addArrangedSubview(courseIDTitleLabel)

        courseIDLabel.text = "\(section.courseNum)"
        courseIDLabel.textAlignment = .center
        courseIDLabel.adjustsFontSizeToFitWidth = true
        courseIDLabel.font = ._60Bold
        courseIDLabel.textColor = .white
        courseIDStackView.addArrangedSubview(courseIDLabel)

        homeButton.setTitle("BACK TO HOME", for: .normal)
        homeButton.titleLabel?.font = ._18Semibold
        homeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.on(.touchUpInside, presentHomeViewController)
        view.addSubview(homeButton)

        studentCenterButton.layer.cornerRadius = 4
        studentCenterButton.layer.borderWidth = 1
        studentCenterButton.layer.borderColor = UIColor.white.cgColor
        studentCenterButton.setTitle("OPEN STUDENT CENTER", for: .normal)
        studentCenterButton.titleLabel?.font = ._18Semibold
        studentCenterButton.setTitleColor(.white, for: .normal)
        studentCenterButton.on(.touchUpInside, openStudentCenter)
        view.addSubview(studentCenterButton)

        // Setup constraints
        availableLabel.snp.makeConstraints { make in
            let constaint = isOlderModel() ? 40 : 91
            make.top.equalToSuperview().inset(constaint)
            make.leading.trailing.equalToSuperview().inset(91)
        }

        courseTitleLabel.snp.makeConstraints { make in
            let constaint = isOlderModel() ? 24 : 43
            make.top.equalTo(availableLabel.snp.bottom).offset(constaint)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        courseIDStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        homeButton.snp.makeConstraints { make in
            let constaint = isOlderModel() ? 50 : 145
            make.bottom.equalToSuperview().inset(constaint)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        studentCenterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(267)
            make.height.equalTo(56)
            make.bottom.equalTo(homeButton.snp.top).offset(-24)
        }
    }

    private func isOlderModel() -> Bool {
        if UIScreen.main.nativeBounds.height == 1136 || UIScreen.main.nativeBounds.height == 1334 || UIScreen.main.nativeBounds.height == 1920 || UIScreen.main.nativeBounds.height == 2208 {
            return true
        }
        return false
    }

    private func presentHomeViewController(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func openStudentCenter(_ button: UIButton) {
        if let url = URL(string: "https://www.studentcenter.cornell.edu/") {
            UIApplication.shared.open(url)
        }
    }

}
