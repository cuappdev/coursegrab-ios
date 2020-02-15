//
//  HomeTableViewCell.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 1/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class HomeTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let courseLabel = UILabel()
    private let enrollButton = UIButton(type: .roundedRect)
    private let removeButton = UIButton(type: .roundedRect)
    private let sectionLabel = UILabel()
    private let statusBadge = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup appearance
        
        selectionStyle = .none
        
        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOffset = .zero
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        
        courseLabel.font = ._14Medium
        courseLabel.textColor = .courseGrabGray
        containerView.addSubview(courseLabel)
        
        enrollButton.layer.cornerRadius = 2
        enrollButton.setTitleColor(.white, for: .normal)
        enrollButton.setTitle("ENROLL", for: .normal)
        enrollButton.titleLabel?.font = ._12Medium
        enrollButton.backgroundColor = .black
        containerView.addSubview(enrollButton)
        
        removeButton.layer.cornerRadius = 2
        removeButton.setTitleColor(.courseGrabRuby, for: .normal)
        removeButton.setTitle("REMOVE", for: .normal)
        removeButton.titleLabel?.font = ._12Medium
        removeButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        removeButton.layer.borderWidth = 1
        containerView.addSubview(removeButton)
        
        sectionLabel.font = ._14Medium
        sectionLabel.textColor = .courseGrabGray
        containerView.addSubview(sectionLabel)
        
        statusBadge.contentMode = .scaleAspectFit
        containerView.addSubview(statusBadge)
        
        titleLabel.font = ._16Semibold
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        
        // Setup constraints

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        courseLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        enrollButton.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(12)
            make.leading.equalTo(containerView.snp.centerX).offset(9)
            make.height.equalTo(24)
            make.trailing.bottom.equalToSuperview().inset(16)
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(12)
            make.leading.equalTo(16)
            make.height.equalTo(24)
            make.trailing.equalTo(containerView.snp.centerX).inset(9)
            make.bottom.equalToSuperview().inset(16)
        }
        
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(16)
        }
        
        statusBadge.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(2)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(16)
            make.trailing.equalTo(statusBadge.snp.leading).inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for section: Section) {
        courseLabel.text = String(section.courseNum)
        enrollButton.isHidden = section.status != .open
        sectionLabel.text = section.section
        statusBadge.image = section.status.icon
        titleLabel.text = section.title

        if section.status == .open {
            removeButton.snp.remakeConstraints { make in
                make.top.equalTo(sectionLabel.snp.bottom).offset(12)
                make.leading.equalTo(16)
                make.height.equalTo(24)
                make.trailing.equalTo(containerView.snp.centerX).inset(9)
                make.bottom.equalToSuperview().inset(16)
            }
        } else {
            removeButton.snp.remakeConstraints { make in
                make.top.equalTo(sectionLabel.snp.bottom).offset(12)
                make.leading.equalTo(16)
                make.height.equalTo(24)
                make.trailing.bottom.equalToSuperview().inset(16)
            }
        }
    }
    
}
