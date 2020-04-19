//
//  SearchTableViewCell.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 2/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    private let arrowImageView = UIImageView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let trackingStackView = UIStackView()

    var untrackSection: ((Section) -> Void)? {
        didSet(handler) {
            for subview in trackingStackView.subviews {
                if let sectionView = subview as? TrackingSectionView {
                    sectionView.untrackSection = handler
                }
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup appearance

        selectionStyle = .none

        arrowImageView.image = .arrowIcon
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .scaleAspectFit
        containerView.addSubview(arrowImageView)

        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOffset = .zero
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)

        titleLabel.font = ._16Semibold
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)

        trackingStackView.axis = .vertical
        containerView.addSubview(trackingStackView)

        // Setup constraints

        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }

    func configure(for course: Course) {
        titleLabel.text = "\(course.subjectCode) \(course.courseNum): \(course.title)"

        trackingStackView.subviews.forEach { $0.removeFromSuperview() }

        let trackingSections = course.sections.filter { $0.isTracking }

        for section in trackingSections {
            let sectionView = TrackingSectionView()
            sectionView.configure(for: section)
            trackingStackView.addArrangedSubview(sectionView)
        }

        if trackingSections.count > 0 {
            titleLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
                make.top.leading.equalToSuperview().inset(16)
            }

            trackingStackView.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(11)
                make.bottom.leading.trailing.equalToSuperview()
            }
        } else {
            titleLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
                make.top.bottom.leading.equalToSuperview().inset(16)
            }

            trackingStackView.snp.removeConstraints()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private class TrackingSectionView: UIView {

    private let divider = UIView()
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private let statusBadge = UIImageView()
    private let subtitleLabel = UILabel()
    private let trackingButton = UIButton(type: .roundedRect)
    private var section: Section?

    var untrackSection: ((Section) -> Void)?

    init() {
        super.init(frame: .zero)

        // Setup appearance

        divider.backgroundColor = .courseGrabBorder
        addSubview(divider)

        trackingButton.layer.cornerRadius = 2
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        trackingButton.titleLabel?.font = ._12Medium
        trackingButton.setTitle("REMOVE", for: .normal)
        trackingButton.setTitleColor(.courseGrabRuby, for: .normal)
        trackingButton.layer.borderColor = UIColor.courseGrabRuby.cgColor
        trackingButton.on(.touchUpInside, removeCourse)
        addSubview(trackingButton)

        statusBadge.contentMode = .scaleAspectFit
        addSubview(statusBadge)

        subtitleLabel.font = ._14Semibold
        subtitleLabel.adjustsFontSizeToFitWidth = true
        addSubview(subtitleLabel)

        // Setup constraints

        divider.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(1)
        }

        statusBadge.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(divider.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(16)
        }

        trackingButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(90)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(subtitleLabel.snp.centerY)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusBadge.snp.trailing).offset(12)
            make.trailing.equalTo(trackingButton.snp.leading).offset(-12)
            make.centerY.equalTo(statusBadge.snp.centerY)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for section: Section) {
        self.section = section
        statusBadge.image = section.status.icon
        subtitleLabel.text = section.section
    }

    private func removeCourse(_ button: UIButton) {
        guard let section = section else { return }
        untrackSection?(section)
        selectionFeedbackGenerator.selectionChanged()
    }

}
