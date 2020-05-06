//
//  SettingsViewController.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import MessageUI
import SnapKit
import SPPermissions
import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    private let contentView = UIView()
    private let mobileSwitch = UISwitch()

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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setMobileSwitchOn),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.pan(pan)
        view.tap(tap)

        // Setup containers
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        
        let stackView = UIStackView()
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
        mobileSwitch.on(.valueChanged, toggleNotificationsEnabled)
        mobileSwitch.transform = CGAffineTransform(scaleX: 24 / 31, y: 24 / 31).translatedBy(x: 5.5, y: 0)
        setMobileSwitchOn()
        mobileStackView.addArrangedSubview(mobileSwitch)
        
        let calendarButton = UIButton(type: .system)
        calendarButton.setAttributedTitle(
            NSAttributedString(
                string: "Cornell Academic Calendar",
                attributes: [
                    .foregroundColor: UIColor.courseGrabHotlink,
                    .font: UIFont._16Semibold
                ]
            ),
            for: .normal
        )
        calendarButton.contentHorizontalAlignment = .left
        calendarButton.on(.touchUpInside, openCalendar)
        stackView.addArrangedSubview(calendarButton)
        
        let feedbackButton = UIButton(type: .system)
        feedbackButton.setAttributedTitle(
            NSAttributedString(
                string: "Leave Feedback",
                attributes: [
                    .foregroundColor: UIColor.courseGrabHotlink,
                    .font: UIFont._16Semibold
                ]
            ),
            for: .normal
        )
        feedbackButton.contentHorizontalAlignment = .left
        feedbackButton.on(.touchUpInside, leaveFeedback)
        stackView.addArrangedSubview(feedbackButton)
        
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
    
    override func viewDidLayoutSubviews() {
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }

}

// MARK: - Links

extension SettingsViewController {
    
    private func leaveFeedback(_ button: UIButton) {
        let emailAddress = "team@cornellappdev.com"
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([emailAddress])
            mailComposerVC.setSubject("CourseGrab Feedback")
            mailComposerVC.setMessageBody("", isHTML: true)
            
            AppDevAnalytics.shared.logFirebase(FeedbackSuccessPayload())
            
            present(mailComposerVC, animated: true)
        } else {
            let title = "Couldn't Send Email"
            let message = "Please add an email account in Settings > Passwords & Accounts > Add Account. You can also contact us at \(emailAddress) to send feedback."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Email Settings", style: .default, handler: { _ in
                if let url = URL(string: "App-Prefs:") {
                    UIApplication.shared.open(url)
                }
                AppDevAnalytics.shared.logFirebase(FeedbackErrorPayload(description: "Opened Email Settings"))
            }))
            alertController.addAction(UIAlertAction(title: "Copy Address to Clipboard", style: .default, handler: { _ in
                UIPasteboard.general.string = emailAddress
                AppDevAnalytics.shared.logFirebase(FeedbackErrorPayload(description: "Copy Address to Clipboard"))
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                AppDevAnalytics.shared.logFirebase(FeedbackErrorPayload(description: "Cancelled"))
            }))
            present(alertController, animated: true)
        }
    }
    
    private func openCalendar(_ button: UIButton) {
        AppDevAnalytics.shared.logFirebase(CornellCalendarPressPayload())
        if let url = URL(string: "https://registrar.cornell.edu/academic-calendar") {
            UIApplication.shared.open(url)
        }
    }
    
}

// MARK: - Sign out

extension SettingsViewController {

    private func signOut(_ button: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true) {
            User.current?.signOut()
        }
    }

}

// MARK: - Notifications

extension SettingsViewController {
    
    @objc private func setMobileSwitchOn() {
        mobileSwitch.isUserInteractionEnabled = false
        mobileSwitch.isOn = UserDefaults.standard.areNotificationsEnabled
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.mobileSwitch.isOn = settings.authorizationStatus == .authorized && UserDefaults.standard.areNotificationsEnabled
                self.mobileSwitch.isUserInteractionEnabled = true
            }
        }
    }
    
    private func toggleNotificationsEnabled(_ sender: UISwitch) {
        AppDevAnalytics.shared.logFirebase(MobileAlertPressPayload())
        sender.isUserInteractionEnabled = false
        let enable = sender.isOn
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                NetworkManager.shared.enableNotifications(enabled: enable).observe { result in
                    DispatchQueue.main.async {
                        sender.isUserInteractionEnabled = true
                        switch result {
                        case .value(let response):
                            if response.success {
                                UserDefaults.standard.areNotificationsEnabled = sender.isOn
                            } else {
                                sender.isOn = !sender.isOn
                            }
                        case .error(let error):
                            print(error)
                        }
                    }
                }
            default:
                DispatchQueue.main.async {
                    sender.isOn = false
                    sender.isUserInteractionEnabled = true
                    self.displayPermissionModal()
                }
            }
        }
    }
    
}

// MARK: - SPPermissionsDataSource

extension SettingsViewController: SPPermissionsDataSource {

    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        cell.permissionTitleLabel.text = "Notifications"
        cell.permissionDescriptionLabel.text = "We'll tell you when a section opens!"
        cell.iconView.color = .courseGrabGreen
        cell.button.allowTitle = "Allow"
        cell.button.allowedTitle = "Allowed"
        cell.button.allowedBackgroundColor = .courseGrabGreen
        cell.button.allowBackgroundColor = .courseGrabGreen
        cell.button.allowTitleColor = .white
        return cell
    }
    
}

// MARK: - SPPermissionsDelegate

extension SettingsViewController: SPPermissionsDelegate {
    
    private func displayPermissionModal() {
        let controller = SPPermissions.dialog([.notification])
        controller.titleText = "Get In Your Courses"
        controller.footerText = "Push notifications enhance the CourseGrab experience."
        controller.dataSource = self
        controller.delegate = self
        controller.present(on: self)
    }

    func didAllow(permission: SPPermission) {
        mobileSwitch.isOn = UserDefaults.standard.areNotificationsEnabled
        UserDefaults.standard.didPromptPermission = true
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func didHide(permissions ids: [Int]) {
        UserDefaults.standard.didPromptPermission = true
    }
    
    func didDenied(permission: SPPermission) {
        UserDefaults.standard.didPromptPermission = true
    }

    func deniedData(for permission: SPPermission) -> SPPermissionDeniedAlertData? {
        if permission == .notification {
            let data = SPPermissionDeniedAlertData()
            data.alertOpenSettingsDeniedPermissionTitle = "Permission denied"
            data.alertOpenSettingsDeniedPermissionDescription = "If you would like to receive push notifications for your courses, go to settings."
            data.alertOpenSettingsDeniedPermissionButtonTitle = "Settings"
            data.alertOpenSettingsDeniedPermissionCancelTitle = "Cancel"
            return data
        } else {
            // If returned nil, alert will not show.
            return nil
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

// MARK: - MailComomposer delegate

extension SettingsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if let error = error {
            print("Mail error: " + error.localizedDescription)
        }
    }
    
}
