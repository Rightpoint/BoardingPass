//
//  BoardingNavigationController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

struct TransitionState {
    enum Direction {
        case push
        case pop
        case none
    }

    var direction: Direction = .none
    var previousState: [UIViewController]?

    init(direction: Direction, previousState: [UIViewController]) {
        self.direction = direction
        self.previousState = previousState
    }

    init() {
        direction = .none
        previousState = nil
    }
}

// MARK: - Core

#if swift(>=3.0)

open class BoardingNavigationController: UINavigationController {

    let panGestureRecognizer = UIPanGestureRecognizer()
    var transitionState = TransitionState()
    var interactionController: UIPercentDrivenInteractiveTransition?

    /// An array of view controllers used to determine the next or previous view
    /// controller to present in the series. These are ignored if the top view
    /// controller conforms to `BoardingInformation`
    public var viewControllersToPresent: [UIViewController] = []

    /**
     An optional closure that takes a `UINavigationControllerOperation` and returns a
     `UIViewControllerAnimatedTransitioning` object. Used to allow customization of
     the animation. The default value is `HorizontalSlideAnimatedTransiton.init`.
     Setting this value to `nil` will default to the standard navigation controller
     animation.
     */
    public var animatedTransitioningProvider: ((UINavigationControllerOperation) -> UIViewControllerAnimatedTransitioning)? = HorizontalSlideAnimatedTransiton.init

    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configure(gestureRecognizer: panGestureRecognizer, action: #selector(handlePan))
    }
}

#else

public class BoardingNavigationController: UINavigationController {

    let panGestureRecognizer = UIPanGestureRecognizer()
    var transitionState = TransitionState()
    var interactionController: UIPercentDrivenInteractiveTransition?

    /// An array of view controllers used to determine the next or previous view
    /// controller to present in the series. These are ignored if the top view
    /// controller conforms to `BoardingInformation`
    public var viewControllersToPresent: [UIViewController] = []

    /**
     An optional closure that takes a `UINavigationControllerOperation` and returns a
     `UIViewControllerAnimatedTransitioning` object. Used to allow customization of
     the animation. The default value is `HorizontalSlideAnimatedTransiton.init`.
     Setting this value to `nil` will default to the standard navigation controller
     animation.
     */
    public var animatedTransitioningProvider: ((UINavigationControllerOperation) -> UIViewControllerAnimatedTransitioning)? = HorizontalSlideAnimatedTransiton.init

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configure(gestureRecognizer: panGestureRecognizer, action: #selector(handlePan))
    }
}

#endif

// MARK: - Navigation Delegate

#if swift(>=3.0)

extension BoardingNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationControllerOperation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransitioningProvider?(operation)
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}


#else

extension BoardingNavigationController: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransitioningProvider?(operation)
    }

    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

#endif

public extension BoardingNavigationController {
    /**
     Initializes the `BoardingNavigationController` with a populated array of
     view controllers to present. If the array is non-empty then it also sets
     the root view controller to the first element in the array.

     - parameter viewControllersToPresent: The array of view controllers to use
     as default navigation options.
     */
    public convenience init(viewControllersToPresent: [UIViewController]) {
        if let firstViewController = viewControllersToPresent.first {
            self.init(rootViewController: firstViewController)
        }
        else {
            self.init()
        }
        self.viewControllersToPresent = viewControllersToPresent
    }

    /**
     Pushes the next view controller in boarding pass stack if one exists.

     - parameter animated: Specify true to animate the transition or false
     if you do not want the transition to be animated.
     */
    public func pushToNextViewController(animated isAnimated: Bool) {
        if let pushableViewController = topViewController.flatMap(boardingInfo(afterController:)) {
            pushViewController(pushableViewController, animated: isAnimated)
        }
    }

    /**
     Pops to the previous view controller in the boarding pass stack if one exists.

     - parameter animated: Specify true to animate the transition or false
     if you do not want the transition to be animated.
     */
    public func popToPreviousViewController(animated isAnimated: Bool) {
        if let poppableViewController = topViewController.flatMap(boardingInfo(afterController:)) {
            popToAndInsertIfNeeded(poppableViewController, animated: isAnimated)
        }
    }
}

// MARK: - Extensions

// MARK: Actions
private extension BoardingNavigationController {
    func popToAndInsertIfNeeded(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.contains(viewController) {
            if viewControllers.count > 1 {
                viewControllers.insert(viewController,
                                       at: ((viewControllers.endIndex - 1) - 1))
            }
            else {
                viewControllers.insert(viewController, at: viewControllers.startIndex)
            }
        }
        popToViewController(viewController, animated: animated)
    }

#if swift(>=3.0)
    @objc func handlePan(from sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .possible:
            break
        case .changed:
            updateAnimation(forRecognizer: sender)
        case .ended, .failed, .cancelled:
            finishAnimation(forRecognizer: sender)
        }
    }
#else
    @objc func handlePan(from sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began, .Possible:
            break
        case .Changed:
            updateAnimation(forRecognizer: sender)
        case .Ended, .Failed, .Cancelled:
            finishAnimation(forRecognizer: sender)
        }
    }
#endif
}

private extension BoardingNavigationController {

    func viewController(before viewController: UIViewController?) -> UIViewController? {
        guard let vc = viewController else {
            return nil
        }
        guard let index = viewControllersToPresent.index(of: vc) else {
            return nil
        }
        guard index > 0 else {
            return nil
        }

        return viewControllersToPresent[(index - 1)]
    }

    func viewController(after viewController: UIViewController?) -> UIViewController? {
        guard let vc = viewController else {
            return nil
        }
        guard let index = ((viewControllersToPresent.index(of: vc))) else {
            return nil
        }

        let adjustedIndex = index + 1

        guard adjustedIndex < viewControllersToPresent.count else {
            return nil
        }

        return viewControllersToPresent[adjustedIndex]
    }

    func updateAnimation(forRecognizer recognizer: UIPanGestureRecognizer) {
        let xTranslation = recognizer.translation(in: view).x
        let percent = xTranslation / view.frame.width
        if (percent < 0 && transitionState.direction == .pop) ||
            (percent > 0 && transitionState.direction == .push) {
            return
        }
        if (percent > 0.66 && transitionState.direction == .pop) ||
            (percent < -0.66 && transitionState.direction == .push) {
            recognizer.isEnabled = false
            return
        }
        if interactionController == nil {
            interactionController = UIPercentDrivenInteractiveTransition()
        }
        // The transitioning delegate being nil tells us that there isn't another active transition in play
        if transitionState.direction == .none && transitioningDelegate == nil {
            if xTranslation < 0 {
                guard let pushableViewControler = topViewController.flatMap(boardingInfo(afterController:)) else {
                    return
                }
                transitionState = TransitionState(direction: .push, previousState: viewControllers)
                pushViewController(pushableViewControler, animated: true)
            }
            else if xTranslation > 0 {
                guard let poppableViewController = topViewController.flatMap(boardingInfo(beforeController:)) else {
                    return
                }
                transitionState = TransitionState(direction: .pop, previousState: viewControllers)
                popToAndInsertIfNeeded(poppableViewController, animated: true)
            }
        }
        interactionController?.update(abs(percent))
    }

    func boardingInfo(beforeController viewController: UIViewController) -> UIViewController? {
        let poppableViewController: UIViewController?
        if let boardingViewController = viewController as? BoardingInformation {
            poppableViewController = boardingViewController.previousViewController
        }
        else {
            poppableViewController = self.viewController(before: viewController)
        }
        return poppableViewController
    }

    func boardingInfo(afterController viewController: UIViewController) -> UIViewController? {
        let pushableViewControler: UIViewController?
        if let boardingViewController = viewController as? BoardingInformation {
            pushableViewControler = boardingViewController.nextViewController
        }
        else {
            pushableViewControler = self.viewController(after: viewController)
        }
        return pushableViewControler
    }

    func finishAnimation(forRecognizer recognizer: UIPanGestureRecognizer) {
        recognizer.isEnabled = true
        let rawVelocity = recognizer.velocity(in: view).x
        let velocityPercentPerSecond: CGFloat
        switch transitionState.direction {
        case .pop:
            velocityPercentPerSecond =  rawVelocity / view.frame.width
        case .push:
            velocityPercentPerSecond =  -rawVelocity / view.frame.width
        case .none:
            velocityPercentPerSecond = 0
        }
        let percentComplete = interactionController?.percentComplete ?? 0
        if percentComplete > 0.5 || percentComplete + velocityPercentPerSecond > 0.75 {
            interactionController?.finish()
            interactionController = nil
            transitionState = TransitionState()
        }
        else {
            cleanUpAnimation()
        }
    }

    func cleanUpAnimation() {
        interactionController?.cancel()
        if let previousState = transitionState.previousState {
            viewControllers = previousState
        }
        interactionController = nil
        DispatchQueue.main.async {
            self.transitionState = TransitionState()
        }
    }

    func configure(gestureRecognizer recognizer: UIGestureRecognizer, action: Selector) {
        recognizer.addTarget(self, action: action)
        view.addGestureRecognizer(recognizer)
    }

}

private extension UISwipeGestureRecognizer {

    convenience init(direction: UISwipeGestureRecognizerDirection) {
        self.init()
        self.direction = direction
    }

}
