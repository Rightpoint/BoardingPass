//
//  OnboardingWrapperViewController.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BoardingPass

struct Font {
    static let onboardingFont: UIFont = UIFont.systemFont(ofSize: 26.0)
}

protocol BackgroundColorProvider {
    var backgroundColor: UIColor { get }
    var currentProgress: Progress { get }
}

public extension UIViewControllerTransitionCoordinatorContext {
    var toViewController: UIViewController? {
        return viewController(forKey: UITransitionContextToViewControllerKey)
    }

    var fromViewController: UIViewController? {
        return viewController(forKey: UITransitionContextFromViewControllerKey)
    }
}

extension BackgroundColorProvider {
    func animation(_ container: UIViewController?, animated: Bool) -> (() -> ()) {
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

    // We're creating a non-standard progress slider because the UIProgressVie
    // has a visual glitch when the animation is cancelled, probably due to
    // CALayer animations
    let progressSlider = UIView()
    var progress = Progress() {
        didSet {
            let progressAmount = CGFloat(progress.fractionCompleted)
            var newTransform = CGAffineTransform.identity
            newTransform = newTransform.translatedBy(x: (-view.frame.width + (view.frame.width * progressAmount)) / 2, y: 0)
            newTransform = newTransform.scaledBy(x: progressAmount, y: 1)
            progressSlider.transform = newTransform
        }
    }

    static func sampleOnboarding() -> OnboardingWrapperViewController {
        let onboarding = OnboardingWrapperViewController(viewControllersToPresent: [FirstViewController(), SecondViewController(), ThirdViewController()])
        return onboarding
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.addSubview(progressSlider)
        progressSlider.frame.size.height = 4
        progressSlider.frame.size.width = navigationBar.frame.width
        progressSlider.frame.origin.x = navigationBar.frame.origin.x
        progressSlider.frame.origin.y = navigationBar.frame.maxY - progressSlider.frame.height
        progressSlider.backgroundColor = .red
        view.backgroundColor = UIColor.white
    }

}
