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

    extension UIViewController {
        @nonobjc var parent: UIViewController? {
            return parentViewController
        }

        @nonobjc var transitionCoordinator: UIViewControllerTransitionCoordinator? {
            return transitionCoordinator()
        }
    }

    // MARK: - Animations

    extension UIViewAnimationOptions {
        @nonobjc static var beginFromCurrentState = UIViewAnimationOptions.BeginFromCurrentState
    }

    extension UIView {
        @nonobjc class func animate(withDuration duration: NSTimeInterval, delay: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
            animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
        }
    }

    // MARK: - Transitions

    extension UIViewControllerContextTransitioning {
        func viewController(forKey key: String) -> UIViewController? {
            return viewControllerForKey(key)
        }
    }

    extension UIViewControllerContextTransitioning {
        var containerView: UIView {
            return containerView()
        }
    }

    public typealias TimeInterval = NSTimeInterval
    extension HorizontalSlideAnimatedTransiton {

        public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            animateTransition(using: transitionContext)
        }

        public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            return transitionDuration(using: transitionContext)
        }

    }

    extension UITransitionContextViewControllerKey {
        @nonobjc static let from: String = UITransitionContextFromViewControllerKey
        @nonobjc static let to: String = UITransitionContextToViewControllerKey
    }

    extension UIViewControllerTransitionCoordinator {
        func animateAlongsideTransition(in view: UIView?,
                                           animation theAnimation: ( (UIViewControllerTransitionCoordinatorContext) -> Void)?,
                                           completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
            return animateAlongsideTransitionInView(view, animation: theAnimation, completion: completion)
        }
    }

    extension UIViewControllerTransitionCoordinatorContext {
        @nonobjc var isAnimated: Bool {
            return isAnimated()
        }

        @nonobjc var isCancelled: Bool {
            return isCancelled()
        }
    }

    extension UIPercentDrivenInteractiveTransition {
        @nonobjc func cancel() {
            cancelInteractiveTransition()
        }

        @nonobjc func update(percentComplete: CGFloat) {
            updateInteractiveTransition(percentComplete)
        }

        @nonobjc func finish() {
            finishInteractiveTransition()
        }
    }

    extension UIPanGestureRecognizer {
        @nonobjc var isEnabled: Bool {
            set(newVal) {
                enabled = newVal
            }
            get {
                return enabled
            }
        }

        @nonobjc func translation(in view: UIView?) -> CGPoint {
            return translationInView(view)
        }

        @nonobjc func velocity(in view: UIView?) -> CGPoint {
            return velocityInView(view)
        }
    }

    // MARK: - Transform

    extension CGAffineTransform {
        @nonobjc static let identity: CGAffineTransform = CGAffineTransformIdentity

        init(translationX: CGFloat, y: CGFloat) {
            self = CGAffineTransformMakeTranslation(translationX, y)
        }
    }

    // MARK: - Dispatch

    struct DispatchQueue {
        @nonobjc static var main = DispatchQueue()
        func async(work: () -> Swift.Void) {
            dispatch_async(dispatch_get_main_queue(), { 
                work()
            })
        }
    }

    // MARK: - Array

    extension Array where Element: Equatable {

        func index(of element: Element) -> Int? {
            return indexOf(element)
        }

        mutating func insert(newElement: Element, at: Int) {
            insert(newElement, atIndex: at)
        }

    }

#endif
