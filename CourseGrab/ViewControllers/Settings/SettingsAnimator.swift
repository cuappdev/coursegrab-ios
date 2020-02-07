//
//  SettingsAnimator.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class SettingsAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.2
    var isPresenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresent(transitionContext: transitionContext)
        } else {
            animateDismiss(transitionContext: transitionContext)
        }
    }
    
    private func animatePresent(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        containerView.addSubview(toView)
        
        let toViewColor = toView.backgroundColor
        toView.backgroundColor = .clear
        
        for subview in toView.subviews {
            subview.layoutIfNeeded()
            subview.transform = CGAffineTransform(translationX: 0, y: subview.frame.height)
        }
        
        UIView.animate(withDuration: duration) {
            toView.backgroundColor = toViewColor
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            for subview in toView.subviews {
                subview.transform = .identity
            }
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func animateDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            fromView.backgroundColor = .clear
            
            for subview in fromView.subviews {
                let transform = CGAffineTransform(translationX: 0, y: subview.frame.height)
                subview.transform = transform
            }
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
}
