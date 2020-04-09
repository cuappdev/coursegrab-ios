//
//  SearchTableViewHeader.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchTableViewHeader: UITableViewHeaderFooterView {

    private let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white
        
        titleLabel.font = ._20Semibold
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(24)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(numResults: Int) {
        titleLabel.text = "\(numResults) Result\(numResults == 1 ? "" : "s")"
    }
    
}
