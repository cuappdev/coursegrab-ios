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

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Setup appearance

        view.backgroundColor = .courseGrabBlack
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Welcome to"
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = ._27Medium
        view.addSubview(subtitleLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = "CourseGrab"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = ._40Bold
        view.addSubview(titleLabel)
        
        let logoView = UIImageView()
        logoView.image = .courseGrabLogo
        logoView.contentMode = .scaleAspectFit
        view.addSubview(logoView)
        
        let signInButton = GIDSignInButton()
        signInButton.style = .wide
        view.addSubview(signInButton)

        // Setup constraints

        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(logoView.snp.top).offset(-44)
            make.centerX.equalToSuperview()
        }
        
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-23)
            make.width.equalTo(143.3)
            make.height.equalTo(139.9)
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoView.snp.bottom).offset(44)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
