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

    private var section: Section?

    private let containerView = UIView()
    private let courseLabel = PillLabel()
    private let enrollButton = UIButton(type: .roundedRect)
    private let modalityLabel = PillLabel()
    private let removeButton = UIButton(type: .roundedRect)
    private let sectionLabel = UILabel()
    private let statusBadge = UIImageView()
    private let titleLabel = UILabel()
    private let popularityImageView = UIImageView()
    private let popularityLabel = UILabel()

    var untrackSection: ((Section) -> Void)?

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
        
        popularityImageView.image = UIImage.popularityIcon
        containerView.addSubview(popularityImageView)

        popularityLabel.font = ._12Medium
        popularityLabel.textColor = .courseGrabMediumGray
        containerView.addSubview(popularityLabel)
        
        courseLabel.clipsToBounds = true
        courseLabel.layer.cornerRadius = 12
        courseLabel.backgroundColor = .courseGrabVeryLightGray
        courseLabel.font = ._14Medium
        courseLabel.textColor = .courseGrabBlack
        containerView.addSubview(courseLabel)

        enrollButton.layer.cornerRadius = 2
        enrollButton.setTitleColor(.white, for: .normal)
        enrollButton.setTitle("ENROLL", for: .normal)
        enrollButton.titleLabel?.font = ._12Medium
        enrollButton.backgroundColor = .black
        enrollButton.on(.touchUpInside, enroll)
        containerView.addSubview(enrollButton)
        
        modalityLabel.clipsToBounds = true
        modalityLabel.layer.cornerRadius = 12
        modalityLabel.backgroundColor = .courseGrabGray
        modalityLabel.font = ._12Semibold
        modalityLabel.textColor = .courseGrabWhite
        containerView.addSubview(modalityLabel)

        removeButton.layer.cornerRadius = 2
        removeButton.setTitleColor(.courseGrabRuby, for: .normal)
        removeButton.setTitle("REMOVE", for: .normal)
        removeButton.titleLabel?.font = ._12Medium
        removeButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        removeButton.layer.borderWidth = 1
        removeButton.on(.touchUpInside, removeSection)
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
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        courseLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(18)
            make.height.equalTo(24)
        }

        enrollButton.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(18)
            make.leading.equalTo(containerView.snp.centerX).offset(4)
            make.height.equalTo(37)
            make.trailing.bottom.equalToSuperview().inset(18)
        }
        
        modalityLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(courseLabel.snp.trailing).offset(5)
            make.height.equalTo(24)
        }

        removeButton.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(18)
            make.height.equalTo(37)
            make.trailing.equalTo(containerView.snp.centerX).inset(4)
            make.leading.bottom.equalToSuperview().inset(18)
        }

        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(courseLabel.snp.bottom).offset(8)
            make.leading.equalTo(18)
        }

        statusBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(18)
            make.size.equalTo(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(18)
            make.trailing.equalToSuperview().inset(40)
        }
        
        popularityImageView.snp.makeConstraints { make in
            make.top.equalTo(courseLabel.snp.bottom).offset(9)
            make.trailing.equalTo(popularityLabel.snp.leading).inset(-4)
            make.width.equalTo(16)
            make.height.equalTo(12)
        }
        
        popularityLabel.snp.makeConstraints { make in
            make.top.equalTo(courseLabel.snp.bottom).offset(8)
            make.trailing.equalTo(statusBadge.snp.trailing)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for section: Section) {
        self.section = section
        courseLabel.text = String(section.catalogNum)
        enrollButton.isHidden = section.status != .open
        modalityLabel.text = section.mode
        sectionLabel.text = section.getSectionByTimezone()
        statusBadge.image = section.status.icon
        titleLabel.text = "\(section.subjectCode) \(section.courseNum): \(section.title)"
        popularityLabel.text = "\(section.numTracking) tracking"


        if section.status == .open {
            removeButton.snp.remakeConstraints { make in
                make.top.equalTo(sectionLabel.snp.bottom).offset(18)
                make.height.equalTo(37)
                make.trailing.equalTo(containerView.snp.centerX).inset(4)
                make.leading.bottom.equalToSuperview().inset(18)
            }
        } else {
            removeButton.snp.remakeConstraints { make in
                make.top.equalTo(sectionLabel.snp.bottom).offset(18)
                make.height.equalTo(37)
                make.leading.trailing.bottom.equalToSuperview().inset(18)
            }
        }
    }
    func setBackgroundColor(isHighlighted: Bool){
        if isHighlighted{
            self.containerView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        }
        else{
         self.containerView.backgroundColor = .white
        }
    }
    

    private func removeSection(_ button: UIButton) {
        guard let section = section else { return }
        untrackSection?(section)
    }

    private func enroll(_ button: UIButton) {
        let description = "\(section?.subjectCode ?? "") \(section?.courseNum ?? 0): \(section?.title ?? "") - \(section?.section ?? "")"
        AppDevAnalytics.shared.logFirebase(EnrollSectionPressPayload(courseTitle: description, catalogNum: section?.catalogNum ?? -1))
        UISelectionFeedbackGenerator().selectionChanged()
        if let url = URL(string: "https://studentcenter.cornell.edu") {
            UIApplication.shared.open(url)
        }
    }
}

class PillLabel: UILabel {
    
    @IBInspectable private let topInset: CGFloat = 0.0
    @IBInspectable private let bottomInset: CGFloat = 0.0
    @IBInspectable private let leftInset: CGFloat = 10.0
    @IBInspectable private let rightInset: CGFloat = 10.0

   override func drawText(in rect: CGRect) {
      let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
   }

   override var intrinsicContentSize: CGSize {
      get {
         var contentSize = super.intrinsicContentSize
         contentSize.height += topInset + bottomInset
         contentSize.width += leftInset + rightInset
         return contentSize
      }
   }
}
