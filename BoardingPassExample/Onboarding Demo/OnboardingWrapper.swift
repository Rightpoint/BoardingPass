//
//  OnboardingWrapper.swift
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
        return {
            (container as? OnboardingWrapper)?.progressBar.setProgress(Float(progress.fractionCompleted), animated: animated)
            container?.view.backgroundColor = color
        }
    }

    func cancellation(context: UIViewControllerTransitionCoordinatorContext) {
//        guard let progressBar = ((self as? UIViewController)?.parentViewController as? OnboardingWrapper)?.progressBar else {
//            return
//        }
//        print(progressBar.progress)
    }

}

class OnboardingWrapper: BoardingNavigationController {

    var progressBar = UIProgressView(progressViewStyle: .Bar)

    static func sampleOnboarding() -> OnboardingWrapper {
        let onboarding = OnboardingWrapper.init(rootViewController: FirstViewController())
        onboarding.navigationBar.addSubview(onboarding.progressBar)
        onboarding.progressBar.frame.size.width = onboarding.navigationBar.frame.width
        onboarding.progressBar.frame.origin.x = onboarding.navigationBar.frame.origin.x
        onboarding.progressBar.frame.origin.y = onboarding.navigationBar.frame.maxY - onboarding.progressBar.frame.height
        return onboarding
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.whiteColor()
    }

}
