//
//  SettingsViewController.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class SettingsViewController: UIViewController {

    private let contentView = UIView()
    private let stackView = UIStackView()

    private var lastPanFraction: CGFloat = 0
    private var transitionAnimator = SettingsAnimator()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        transitioningDelegate = self
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
            make.bottom.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        // Setup children
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.font = ._24Bold
        stackView.addArrangedSubview(settingsLabel)
        stackView.setCustomSpacing(27, after: settingsLabel)

        let mobileStackView = UIStackView()
        stackView.addArrangedSubview(mobileStackView)
        let mobileLabel = UILabel()
        mobileLabel.text = "Mobile Alerts"
        mobileLabel.font = ._16Semibold
        mobileStackView.addArrangedSubview(mobileLabel)
        let mobileSwitch = UISwitch()
        mobileSwitch.on(.touchUpInside, toggleNotificationsEnabled)
        mobileSwitch.isOn = UserDefaults.standard.areNotificationsEnabled
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
        calendarButton.on(.touchUpInside, openCalendar)
        stackView.addArrangedSubview(calendarButton)
        
        let accountStackView = UIStackView()
        stackView.addArrangedSubview(accountStackView)

        let accountLabel = UILabel()
        accountLabel.font = ._16Semibold
        accountLabel.textColor = .courseGrabDarkGray
        accountLabel.text = User.current?.email
        accountStackView.addArrangedSubview(accountLabel)
        
        let signOutButton = UIButton(type: .system)
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.courseGrabRuby, for: .normal)
        signOutButton.titleLabel?.font = ._16Semibold
        signOutButton.on(.touchUpInside, signOut)
        signOutButton.contentHorizontalAlignment = .right
        accountStackView.addArrangedSubview(signOutButton)
    }

    private func openCalendar(_ button: UIButton) {
        if let url = URL(string: "https://registrar.cornell.edu/academic-calendar") {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLayoutSubviews() {
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }

}

// MARK: - Sign out

extension SettingsViewController {

    private func signOut(_ button: UIButton) {
        dismiss(animated: true) {
            User.current?.signOut()
        }
    }

}

// MARK: - Toggle notifications enabled

extension SettingsViewController {
    
    private func toggleNotificationsEnabled(_ sender: UISwitch) {
        sender.isUserInteractionEnabled = false
        
        NetworkManager.shared.enableNotifications(enabled: sender.isOn).observe { result in
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = true
                switch result {
                case .value(let response):
                    if !response.success {
                        sender.isOn = !sender.isOn
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }
    
}

// MARK: - Gesture recognizers

extension SettingsViewController {
    
    private func pan(_ gesture: UIPanGestureRecognizer) {
        let dismissalFraction: CGFloat = 20 / contentView.frame.height
        
        let translation = gesture.translation(in: view).y
        let velocity = gesture.velocity(in: view).y
        let panFraction = translation / contentView.frame.height
        
        switch gesture.state {
        case .changed:
            contentView.transform = CGAffineTransform(translationX: 0, y: min(max(0, translation), contentView.frame.height))
            view.backgroundColor = UIColor.black.withAlphaComponent(min(0.4, 0.4 - panFraction * 0.4))
            
            if velocity > 0 && lastPanFraction < dismissalFraction && panFraction > dismissalFraction {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        case .ended, .cancelled:
            if panFraction > dismissalFraction {
                dismiss(animated: true)
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
            dismiss(animated: true)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// MARK: - Transitioning delegate

extension SettingsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.isPresenting = true
        return transitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.isPresenting = false
        return transitionAnimator
    }
    
}
