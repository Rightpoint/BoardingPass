//
//  BoardingInformation.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public typealias AnimationFactory = (_ container: UIViewController?, _ animated: Bool) -> (() -> Void)
public typealias ContextualAnimation = (_ context: UIViewControllerTransitionCoordinatorContext) -> Void

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
            coordinator.animateAlongsideTransition(in: parentController?.view, animation: animationInContext, completion: completionInContext)
        }
        else {
            animation?(parentController, false)()
            completion?(parentController, false)()
        }
    }
}
