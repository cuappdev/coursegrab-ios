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

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
//        modalPresentationStyle = .fullScreen
//        view.frame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: view.frame.height / 2)
        view.backgroundColor = .clear

        contentView.backgroundColor = .red
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
    }

}
