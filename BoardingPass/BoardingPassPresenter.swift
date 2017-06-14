//
//  BoardingPassPresenter.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

private struct TransitionState {
    enum Direction {
        case push
        case pop
        case none
    }

    var direction: Direction
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

open class BoardingPassPresenter: NSObject {

    fileprivate var transitionState = TransitionState() {
        didSet {
            print(transitionState)
        }
    }
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?

    /// An array of view controllers used to determine the next or previous view
    /// controller to present in the series.
    open var viewControllersToPresent: [UIViewController]

    /// The Navigation Controller that this presenter is acting on behalf of.
    /// This is an unowned relationship so it can be used by a subclass of
    /// UINavigationController or by a Coordinator.
    open unowned var navigationController: UINavigationController

    /// An animation block to perform when the top view controller will change
    open var willChangeTopViewController: (UIViewController) -> Void = { _ in }

    /**
     An optional closure that takes a `UINavigationControllerOperation` and returns a
     `UIViewControllerAnimatedTransitioning` object. Used to allow customization of
     the animation. The default value is `HorizontalSlideAnimatedTransiton.init`.
     Setting this value to `nil` will default to the standard navigation controller
     animation.
     */
    open var animatedTransitioningProvider: ((UINavigationControllerOperation) -> UIViewControllerAnimatedTransitioning)? = HorizontalSlideAnimatedTransiton.init

    public init(navigationController: UINavigationController, viewControllersToPresent: [UIViewController]) {
        self.navigationController = navigationController
        self.viewControllersToPresent = viewControllersToPresent
        super.init()
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(from:)))
        if let firstViewController = viewControllersToPresent.first {
            navigationController.viewControllers = [firstViewController]
        }
        navigationController.view.addGestureRecognizer(panGestureRecognizer)
        navigationController.delegate = self
    }
}

// MARK: - Navigation Delegate

extension BoardingPassPresenter: UINavigationControllerDelegate {

    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let change = willChangeTopViewController
        viewController.perform(coordinatedAnimations: { (_, _) -> (() -> Void) in
            return {
                change(viewController)
            }
        })
    }

    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationControllerOperation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if viewControllersToPresent.contains(toVC) {
            return animatedTransitioningProvider?(operation)
        }
        else {
            return nil
        }
    }

    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

extension BoardingPassPresenter {
    /**
     Pushes the next view controller in boarding pass stack if one exists.

     - parameter animated: Specify true to animate the transition or false
     if you do not want the transition to be animated.
     */
    open func pushToNextViewController(animated isAnimated: Bool) {
        if let pushableViewController = viewController(after: navigationController.topViewController) {
            navigationController.pushViewController(pushableViewController, animated: isAnimated)
        }
    }

    /**
     Pops to the previous view controller in the boarding pass stack if one exists.

     - parameter animated: Specify true to animate the transition or false
     if you do not want the transition to be animated.
     */
    open func popToPreviousViewController(animated isAnimated: Bool) {
        if let poppableViewController = viewController(before: navigationController.topViewController) {
            navigationController.popToAndInsertIfNeeded(poppableViewController, animated: isAnimated)
        }
    }
}

// MARK: Actions
private extension BoardingPassPresenter {

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
}

private extension BoardingPassPresenter {

    func viewController(before viewController: UIViewController?) -> UIViewController? {
        guard let vc = viewController,
            let index = viewControllersToPresent.index(of: vc),
            index > 0 else {
            return nil
        }
        return viewControllersToPresent[index - 1]
    }

    func viewController(after viewController: UIViewController?) -> UIViewController? {
        guard let vc = viewController,
            let index = ((viewControllersToPresent.index(of: vc))),
            index < viewControllersToPresent.count - 1 else {
            return nil
        }

        return viewControllersToPresent[index + 1]
    }

    func updateAnimation(forRecognizer recognizer: UIPanGestureRecognizer) {
        guard let view = navigationController.view else { return }
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
        if transitionState.direction == .none && navigationController.transitioningDelegate == nil {
            if xTranslation < 0 {
                guard let pushableViewControler = viewController(after: navigationController.topViewController) else {
                    return
                }
                transitionState = TransitionState(direction: .push, previousState: navigationController.viewControllers)
                navigationController.pushViewController(pushableViewControler, animated: true)
            }
            else if xTranslation > 0 {
                guard let poppableViewController = viewController(before: navigationController.topViewController) else {
                    return
                }
                transitionState = TransitionState(direction: .pop, previousState: navigationController.viewControllers)
                navigationController.popToAndInsertIfNeeded(poppableViewController, animated: true)
            }
        }
        interactionController?.update(abs(percent))
    }

    func finishAnimation(forRecognizer recognizer: UIPanGestureRecognizer) {
        guard let view = navigationController.view else { return }
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
            navigationController.viewControllers = previousState
        }
        interactionController = nil
        DispatchQueue.main.async {
            self.transitionState = TransitionState()
        }
    }
}

private extension UINavigationController {
    func popToAndInsertIfNeeded(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.contains(viewController) {
            let previousIndex = viewControllers.indices.endIndex.advanced(by: -1)
            viewControllers.insert(viewController, at: previousIndex)
        }

        popToViewController(viewController, animated: animated)
    }
}

private extension UISwipeGestureRecognizer {
    convenience init(direction: UISwipeGestureRecognizerDirection) {
        self.init()
        self.direction = direction
    }
}
