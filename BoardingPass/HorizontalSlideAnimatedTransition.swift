//
//  HorizontalSlideAnimatedTransition.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public class HorizontalSlideAnimatedTransiton: NSObject {

    enum TransitionType {
        case push, pop
    }

    let slideType: TransitionType

    /**
     Initializes a HorizontalSlideAnimatedTransiton for handling a pan gesture on a UINavigationController

     - parameter navigationOperation: The the navigation operation bieng animated
     */
    public init(navigationOperation: UINavigationControllerOperation) {
        switch  navigationOperation {
        case .none, .push:
            slideType = .push
        case .pop:
            slideType = .pop
        }
        super.init()
    }

}

extension HorizontalSlideAnimatedTransiton: UIViewControllerAnimatedTransitioning {

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let presented = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let presenting = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                transitionContext.completeTransition(false)
                return
        }

        // Optional for backward compatibility
        let container: UIView? = transitionContext.containerView

        container?.addSubview(presented.view)
        let width: CGFloat
        switch slideType {
        case .push:
            width = container?.frame.width ?? 0
        case .pop:
            width = -(container?.frame.width ?? 0)
        }
        presented.view.transform = CGAffineTransform(translationX: width, y: 0)
        let animations = {
            presenting.view.transform = CGAffineTransform(translationX: -width, y: 0)
            presented.view.transform = CGAffineTransform.identity
        }
        let completion = { (completed: Bool) in
            if completed {
                presented.view.transform = CGAffineTransform.identity
            }
            else {
                presenting.view.transform = CGAffineTransform.identity
            }
            transitionContext.completeTransition(completed)
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0,
                                   options: [.beginFromCurrentState],
                                   animations: animations, completion: completion)
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}
