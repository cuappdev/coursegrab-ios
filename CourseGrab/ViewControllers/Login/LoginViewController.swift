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
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Setup appearance

        view.backgroundColor = .white
        
        logoView.image = UIImage(named: "coursegrab-logo")
        logoView.contentMode = .scaleAspectFit
        view.addSubview(logoView)
        view.addSubview(signInButton)

        titleLabel.text = "CourseGrab"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = ._44Bold
        view.addSubview(titleLabel)

        // Setup constraints

        logoView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.size.equalTo(250)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(logoView.snp.top).offset(22)
            make.centerX.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoView.snp.bottom)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

}
