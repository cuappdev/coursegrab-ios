//
//  HomeTableViewCell.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 1/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    
    var section: Section? {
        didSet {
            guard let section = section else { return }
            
            courseLabel.text = String(section.courseNum)
            sectionLabel.text = section.section
            statusBadge.image = UIImage(named: "image") // TODO: Update status badge
            titleLabel.text = section.title
            
            // configure remove/enroll buttons depending on whether user is tracking section
            // update constraints on buttons accordingly
        }
    }
    
    private let courseLabel = UILabel()
    private let enrollButton = UIButton(type: .roundedRect)
    private let removeButton = UIButton(type: .roundedRect)
    private let sectionLabel = UILabel()
    private let statusBadge = UIImageView() // TODO: Make image a property of Status
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // setup appearance
        
        selectionStyle = .none
        
        courseLabel.translatesAutoresizingMaskIntoConstraints = false
        courseLabel.font = .boldSystemFont(ofSize: 14)
        courseLabel.textColor = .courseGrabGray
        contentView.addSubview(courseLabel)
        
        enrollButton.translatesAutoresizingMaskIntoConstraints = false
        enrollButton.layer.cornerRadius = 2
        enrollButton.setTitleColor(.white, for: .normal)
        enrollButton.setTitle("ENROLL", for: .normal)
        enrollButton.backgroundColor = .black
        contentView.addSubview(enrollButton)
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.layer.cornerRadius = 2
        removeButton.setTitleColor(.courseGrabRuby, for: .normal)
        removeButton.setTitle("REMOVE", for: .normal)
        removeButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        removeButton.layer.borderWidth = 1
        contentView.addSubview(removeButton)
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.font = .boldSystemFont(ofSize: 14)
        sectionLabel.textColor = .courseGrabGray
        contentView.addSubview(sectionLabel)
        
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        statusBadge.contentMode = .scaleAspectFit
        contentView.addSubview(statusBadge)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        // setup constraints
        
        courseLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.trailing.equalTo(contentView).inset(16)
        }
        
        enrollButton.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.centerX).offset(4.5)
            make.height.equalTo(24)
            make.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(16)
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(12)
            make.leading.equalTo(16)
            make.height.equalTo(24)
            make.trailing.equalTo(contentView.snp.centerX).inset(4.5)
            make.bottom.equalTo(contentView).inset(16)
        }
        
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(16)
        }
        
        statusBadge.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(16)
            make.width.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(statusBadge.snp.leading).inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
