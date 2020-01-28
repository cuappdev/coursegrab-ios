//
//  LoginViewController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import GoogleSignIn
import SnapKit
import UIKit

class LoginViewController: UIViewController {

    private let logoView = UIImageView()
    private let signInButton = GIDSignInButton()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

        setupStackView()
        setupTitleLabel()
        setupLogoView()
        setupSignInButton()
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 40
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTitleLabel() {
        titleLabel.text = "CourseGrab"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        stackView.addArrangedSubview(titleLabel)
    }

    private func setupLogoView() {
        logoView.image = UIImage(named: "image")
        logoView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(logoView)

        logoView.snp.makeConstraints { make in
            make.height.equalTo(128)
        }
    }

    private func setupSignInButton() {
        stackView.addArrangedSubview(signInButton)
    }

}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                // User is not signed in or have signed out
            } else {
                //print("\(error.localizedDescription)")
            }
            return
        }
        let coursesViewController = CoursesViewController()
        let coursesNavigationController = CoursesNavigationController(rootViewController: coursesViewController)
        coursesNavigationController.modalPresentationStyle = .fullScreen
        present(coursesNavigationController, animated: false)
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

