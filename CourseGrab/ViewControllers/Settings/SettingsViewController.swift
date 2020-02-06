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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        contentView.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }

        view.pan(pan)
    }

    private func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: view).y
            contentView.transform = CGAffineTransform(translationX: 0, y: min(max(0, translation), contentView.frame.height))
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view).y
            if velocity > 0 {
                dismiss(velocity: velocity)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.contentView.transform = .identity
                }
            }
        default:
            break
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .clear

        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.frame.height)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.transform = .identity
        })
        UIView.animate(withDuration: 0.1, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }

    private func dismiss(velocity: CGFloat = 1) {
        let yPoints = contentView.frame.height - contentView.transform.ty
        let duration = max(0.1, TimeInterval(yPoints / velocity))

        print(yPoints)

        UIView.animate(withDuration: duration) {
//            self.view.backgroundColor = .clear
        }
        UIView.animate(withDuration: duration, animations: {
            self.contentView.transform = self.contentView.transform.translatedBy(x: 0, y: yPoints)
        }) { _ in
            self.dismiss(animated: false)
        }
    }

}

extension UIView {

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}
