//
//  SettingsViewController.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SettingsViewController: UIViewController {

    private let contentView = UIView()
    private let stackView = UIStackView()

    private var lastPanFraction: CGFloat = 0

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.pan(pan)
        view.tap(tap)

        // Setup containers
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        stackView.axis = .vertical
        stackView.spacing = 17
        stackView.layoutMargins = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        contentView.addSubview(stackView)
        
        // Setup constraints
        contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        // Setup children
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.font = ._24Bold
        stackView.addArrangedSubview(settingsLabel)
        stackView.setCustomSpacing(27, after: settingsLabel)

        let emailStackView = UIStackView()
        stackView.addArrangedSubview(emailStackView)
        let emailLabel = UILabel()
        emailLabel.text = "Email Alerts"
        emailLabel.font = ._16Semibold
        emailStackView.addArrangedSubview(emailLabel)
        let emailSwitch = UISwitch()
        emailSwitch.transform = CGAffineTransform(scaleX: 24 / 31, y: 24 / 31).translatedBy(x: 5.5, y: 0)
        emailStackView.addArrangedSubview(emailSwitch)

        let mobileStackView = UIStackView()
        stackView.addArrangedSubview(mobileStackView)
        let mobileLabel = UILabel()
        mobileLabel.text = "Mobile Alerts"
        mobileLabel.font = ._16Semibold
        mobileStackView.addArrangedSubview(mobileLabel)
        let mobileSwitch = UISwitch()
        mobileSwitch.transform = CGAffineTransform(scaleX: 24 / 31, y: 24 / 31).translatedBy(x: 5.5, y: 0)
        mobileStackView.addArrangedSubview(mobileSwitch)
        
        let calendarButton = UIButton(type: .system)
        calendarButton.setAttributedTitle(
            NSAttributedString(
                string: "Cornell Academic Calendar",
                attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.courseGrabHotlink,
                    .font: UIFont._16Semibold
                ]
            ),
            for: .normal
        )
        calendarButton.contentHorizontalAlignment = .left
        stackView.addArrangedSubview(calendarButton)
        
        let accountStackView = UIStackView()
        stackView.addArrangedSubview(accountStackView)
        let accountLabel = UILabel()
        accountLabel.font = ._16Semibold
        accountLabel.textColor = .courseGrabDarkGray
        accountLabel.text = "dov3@cornell.edu" // placeholder
        accountStackView.addArrangedSubview(accountLabel)
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Sign Out", for: .normal)
        logoutButton.setTitleColor(.courseGrabRuby, for: .normal)
        logoutButton.titleLabel?.font = ._16Semibold
        logoutButton.contentHorizontalAlignment = .right
        accountStackView.addArrangedSubview(logoutButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .clear

        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.frame.height)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.transform = .identity
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        })
    }

    private func dismiss() {
        let transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .clear
            self.contentView.transform = transform
        }) { _ in
            self.dismiss(animated: false)
        }
    }

}

// MARK: - Gesture recognizers

extension SettingsViewController {
    
    private func pan(_ gesture: UIPanGestureRecognizer) {
        let dismissalFraction: CGFloat = 20 / contentView.frame.height
        
        let translation = gesture.translation(in: view).y / 6
        let velocity = gesture.velocity(in: view).y
        let panFraction = translation / contentView.frame.height
        
        switch gesture.state {
        case .changed:
            contentView.transform = CGAffineTransform(translationX: 0, y: min(max(0, translation), contentView.frame.height))
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4 - panFraction * 0.4)
            
            if velocity > 0 && lastPanFraction < dismissalFraction && panFraction > dismissalFraction {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        case .ended, .cancelled:
            if panFraction > dismissalFraction {
                dismiss()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.contentView.transform = .identity
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                }
            }
        default:
            break
        }
        
        lastPanFraction = panFraction
    }
    
    private func tap(_ gesture: UITapGestureRecognizer) {
        if !contentView.frame.contains(gesture.location(in: view)) {
            dismiss()
        }
    }
    
}
