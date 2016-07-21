//
//  HorizontalSlideAnimatedTransition.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public class HorizontalSlideAnimatedTransiton: NSObject {

    private enum TransitionType {
        case Push, Pop
    }

    private let slideType: TransitionType

    public init(navigationOperation: UINavigationControllerOperation) {
        switch  navigationOperation {
        case .None, .Push:
            slideType = .Push
        case .Pop:
            slideType = .Pop
        }
        super.init()
    }

}

extension HorizontalSlideAnimatedTransiton: UIViewControllerAnimatedTransitioning {

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let presented = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            presenting = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            transitionContext.completeTransition(false)
            return
        }
        transitionContext.containerView()?.addSubview(presented.view)
        let width: CGFloat
        switch slideType {
        case .Push:
            width = transitionContext.containerView()?.frame.width ?? 0
        case .Pop:
            width = -(transitionContext.containerView()?.frame.width ?? 0)
        }
        presented.view.transform = CGAffineTransformMakeTranslation(width, 0)
        let animations = {
            presenting.view.transform = CGAffineTransformMakeTranslation(-width, 0)
            presented.view.transform = CGAffineTransformIdentity
        }
        let completion = { (completed: Bool) in
            if completed {
                presented.view.transform = CGAffineTransformIdentity
            }
            else {
                presenting.view.transform = CGAffineTransformIdentity
            }
            transitionContext.completeTransition(completed)
        }
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0,
                                   options: [.BeginFromCurrentState],
                                   animations: animations, completion: completion)
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
}

extension HorizontalSlideAnimatedTransiton: UIViewControllerInteractiveTransitioning {

    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
    }

}
