//
//  BoardingNavigationController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public class BoardingNavigationController: UINavigationController {

    private enum TransitionState {
        case Pushing, Popping
    }

    private let swipeRightGestureRecognizer = UISwipeGestureRecognizer(direction: .Right)
    private let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(direction: .Left)
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var currentTransition: TransitionState?

    var animatedTransitioningProvider: (UINavigationControllerOperation -> UIViewControllerAnimatedTransitioning)? = { navigationOperation in
        return HorizontalSlideAnimatedTransiton(navigationOperation: navigationOperation)
    }

    var interactiveTransitioningProvider: (() -> UIViewControllerInteractiveTransitioning)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
//        configure(swipeRightGestureRecognizer, action: #selector(handleSwipeRight))
//        configure(swipeLeftGestureRecognizer, action: #selector(handleSwipeLeft))
        configure(panGestureRecognizer, action: #selector(handlePan))
    }

}

extension BoardingNavigationController: UINavigationControllerDelegate {

    public func navigationController(navigationController: UINavigationController,
                                     animationControllerForOperation operation: UINavigationControllerOperation,
                                     fromViewController fromVC: UIViewController,
                                     toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransitioningProvider?(operation)
    }

    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioningProvider?()
    }
}

// MARK: - Actions
private extension BoardingNavigationController {
    @objc func handleSwipeRight(sender: UISwipeGestureRecognizer) {
        guard sender.state == UIGestureRecognizerState.Ended else {
            return
        }
        guard let previousViewController = (topViewController as? BoardingInformation)?.previousViewController else {
            return
        }
        if !viewControllers.contains(previousViewController) {
            if viewControllers.count > 1 {
            viewControllers.insert(previousViewController,
                                   atIndex: viewControllers.endIndex.predecessor().predecessor())
            }
            else {
                viewControllers.insert(previousViewController, atIndex: viewControllers.startIndex)
            }
        }
        popToViewController(previousViewController, animated: true)
    }

    @objc func handleSwipeLeft(sender: UISwipeGestureRecognizer) {
        guard sender.state == UIGestureRecognizerState.Ended else {
            return
        }
        guard let nextViewController = (topViewController as? BoardingInformation)?.nextViewController else {
            return
        }
        pushViewController(nextViewController, animated: true)
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            break
        case .Changed:
            if currentTransition == nil {
                let xTranslation = sender.translationInView(view).x
                if xTranslation > 0 {
                    currentTransition = TransitionState.Popping
                }
                else if xTranslation < 0 {
                    currentTransition = TransitionState.Pushing
                }
            }
            break
        case .Ended, .Failed, .Cancelled:
            currentTransition = nil
            break
        case .Possible:
            break
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension BoardingNavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        switch (gestureRecognizer, otherGestureRecognizer) {
        case (panGestureRecognizer, swipeRightGestureRecognizer),
             (panGestureRecognizer, swipeLeftGestureRecognizer):
            return gestureRecognizer.state == .Ended
        default:
            return false
        }
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        switch (gestureRecognizer, otherGestureRecognizer) {
        case (panGestureRecognizer, swipeRightGestureRecognizer),
             (panGestureRecognizer, swipeLeftGestureRecognizer),
             (swipeRightGestureRecognizer, panGestureRecognizer),
             (swipeLeftGestureRecognizer, panGestureRecognizer):
            return true
        default:
            return false
        }
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        switch (gestureRecognizer, otherGestureRecognizer) {
        case (panGestureRecognizer, swipeRightGestureRecognizer),
             (panGestureRecognizer, swipeLeftGestureRecognizer):
            return otherGestureRecognizer.state == .Ended
        default:
            return true
        }
    }
}

private extension BoardingNavigationController {

    func configure(gestureRecognizer: UIGestureRecognizer, action: Selector) {
        gestureRecognizer.addTarget(self, action: action)
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }

}

private extension UISwipeGestureRecognizer {

    convenience init(direction: UISwipeGestureRecognizerDirection) {
        self.init()
        self.direction = direction
    }

}
