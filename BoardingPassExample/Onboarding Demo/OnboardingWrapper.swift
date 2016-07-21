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
        let color = self.backgroundColor
        return {
            container?.view.backgroundColor = color
        }
    }

    func completion(container: UIViewController?, animated: Bool) -> (() -> ()) {
        return {}
    }

    func cancellation(context: UIViewControllerTransitionCoordinatorContext) {
        guard let fromView = context.fromViewController as? BackgroundColorProvider else {
            return
        }
        context.containerView().backgroundColor = fromView.backgroundColor
    }
}

class OnboardingWrapper: BoardingNavigationController {

    static func sampleOnboarding() -> OnboardingWrapper {
        let onboarding = OnboardingWrapper.init(rootViewController: FirstViewController())
        return onboarding
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.whiteColor()
    }

}
