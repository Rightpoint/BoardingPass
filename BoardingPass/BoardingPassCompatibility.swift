//
//  BoardingPassCompatibility.swift
//  BoardingPass
//
//  Created by Adam Tierney on 9/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

#if swift(>=3.0)

    

#else

public typealias TimeInterval = NSTimeInterval

// MARK: - Animations

extension UIViewAnimationOptions {
    static var beginFromCurrentState = UIViewAnimationOptions.BeginFromCurrentState
}

extension UIView {
    @nonobjc final class func animate(withDuration duration: NSTimeInterval, delay: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
        animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
    }
}

    //TODO:
extension UINavigationControllerOperation {
    static let push = UINavigationControllerOperation.Push
    static let pop = UINavigationControllerOperation.Pop
    static let none = UINavigationControllerOperation.None
}

extension UIViewControllerContextTransitioning {
    final func viewController(forKey key: String) -> UIViewController? {
        return viewControllerForKey(key)
    }
}

extension UIViewControllerContextTransitioning {
    var containerView: UIView {
        return containerView()
    }
}

extension UIViewControllerAnimatedTransitioning {

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        animateTransition(using: transitionContext)
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning) { }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) {
        transitionDuration(using: transitionContext)
    }
}

extension UITransitionContextViewControllerKey {
    static let from: String = UITransitionContextFromViewControllerKey
    static let to: String = UITransitionContextToViewControllerKey
}

// MARK: - Transform

extension CGAffineTransform {
    static let identity: CGAffineTransform = CGAffineTransformIdentity

    init(translationX: CGFloat, y: CGFloat) {
        self = CGAffineTransformMakeTranslation(translationX, y)
    }
}

#endif
