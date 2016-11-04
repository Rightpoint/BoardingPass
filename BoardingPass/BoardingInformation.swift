//
//  BoardingInformation.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public protocol BoardingInformation {

    /// Used to determine the next view controller to push in the stack, a nil value means there is no next view,
    /// so no swipe left for next gesture will be allowed
    var nextViewController: UIViewController? { get }
    /// Used to determine the previous view controller to pop to, the default value of the previous view controller
    /// in the navigation stack. A nil value will explicitly disable the swipe right for previous view gesture.
    var previousViewController: UIViewController? { get }

}

#if swift(>=3.0)
    public typealias AnimationFactory = (_ container: UIViewController?, _ animated: Bool) -> (() -> ())
    public typealias ContextualAnimation = (_ context: UIViewControllerTransitionCoordinatorContext) -> ()
#else
    public typealias AnimationFactory = (UIViewController?, Bool) -> (() -> ())
    public typealias ContextualAnimation = (UIViewControllerTransitionCoordinatorContext) -> ()
#endif


public extension UIViewController {

    /**
     A function for handling an animation that may or may not be performed alongside an animation context

     - parameter animation: A closure that takes a view controller and an animated flag and returns an animation block
                            to perform perform, either alongside a context if one exists, with a fallback of applying
                            it to the view
     - parameter completion: A closure that takes a view controller and an animated flag, and returns an animation block
                             to perform alongside a context, with a fallback of applying it to the view
     - parameter cancellation: A cancellation action to handle restoration of any state that isn't properly rolled back
                              if the animation block is cancelled
     */
    final public func perform(coordinatedAnimations animation: AnimationFactory? = nil,
                                                         completion: AnimationFactory? = nil,
                                                         cancellation: ContextualAnimation? = nil) {
        let parentController = self.parent
        let animationInContext: ContextualAnimation = { (context: UIViewControllerTransitionCoordinatorContext) in
            animation?(parentController, context.isAnimated)()
        }
        let completionInContext = { (context: UIViewControllerTransitionCoordinatorContext) in
            if context.isCancelled {
                cancellation?(context)
            }
            else {
                completion?(parentController, context.isAnimated)()
            }
        }
        if let coordinator = transitionCoordinator {
            coordinator.animateAlongsideTransition(in: parent?.view, animation: animationInContext, completion: completionInContext)
        }
        else {
            animation?(parentController, false)()
            completion?(parentController, false)()
        }
    }
}

public extension BoardingInformation {

    var nextViewController: UIViewController? {
        return nil
    }
    var previousViewController: UIViewController? {
        guard let viewController = self as? UIViewController else {
            return nil
        }
        return viewController.navigationController?.viewController(beforeController: viewController)
    }

    var allowGestures: Bool {
        return true
    }

}

private  extension UINavigationController {

    func viewController(beforeController viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.index(of: viewController) else {
            return nil
        }
        guard index > 0 else {
            return nil
        }
        return viewControllers[index.advanced(by: -1)]
    }

}
