//
//  OnboardingWrapperViewController.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BoardingPass

protocol BackgroundColorProvider {
    var backgroundColor: UIColor { get }
    var currentProgress: NSProgress { get }
}

public extension UIViewControllerTransitionCoordinatorContext {
    var toViewController: UIViewController? {
        return viewControllerForKey(UITransitionContextToViewControllerKey)
    }

    var fromViewController: UIViewController? {
        return viewControllerForKey(UITransitionContextFromViewControllerKey)
    }
}

extension BackgroundColorProvider {
    func animation(container: UIViewController?, animated: Bool) -> (() -> ()) {
        let color = backgroundColor
        let progress = currentProgress
        let progressViewController = container as? OnboardingWrapperViewController
        return {
            progressViewController?.progress = progress
            container?.view.backgroundColor = color
        }
    }

}

class OnboardingWrapperViewController: BoardingNavigationController {

    // We're creating a non-standard progress slider because the UIProgressView
    // has a visual glitch when the animation is cancelled, probably due to
    // CALayer animations
    private let progressSlider = UIView()
    var progress = NSProgress() {
        didSet {
            let progressAmount = CGFloat(progress.fractionCompleted)
            var newTransform = CGAffineTransformIdentity
            newTransform = CGAffineTransformTranslate(newTransform, (-view.frame.width + (view.frame.width * progressAmount)) / 2, 0)
            newTransform = CGAffineTransformScale(newTransform, progressAmount, 1)
            progressSlider.transform = newTransform
        }
    }

    static func sampleOnboarding() -> OnboardingWrapperViewController {
        let onboarding = OnboardingWrapperViewController.init(rootViewController: FirstViewController())
        onboarding.navigationBar.addSubview(onboarding.progressSlider)
        onboarding.progressSlider.frame.size.height = 4
        onboarding.progressSlider.frame.size.width = onboarding.navigationBar.frame.width
        onboarding.progressSlider.frame.origin.x = onboarding.navigationBar.frame.origin.x
        onboarding.progressSlider.frame.origin.y = onboarding.navigationBar.frame.maxY - onboarding.progressSlider.frame.height
        onboarding.progressSlider.backgroundColor = .redColor()
        return onboarding
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.whiteColor()
    }

}
