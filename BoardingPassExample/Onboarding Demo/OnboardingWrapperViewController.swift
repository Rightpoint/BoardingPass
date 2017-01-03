//
//  OnboardingNavigationViewController.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BoardingPass

extension UIFont {
    static let onboardingFont: UIFont = UIFont.systemFont(ofSize: 26.0)
}

protocol BackgroundColorProvider: class {

    weak var onboardingDelegate: OnboardingViewControllerDelegate? { get set }
    var backgroundColor: UIColor { get }
    var currentProgress: Progress { get }

}

extension BackgroundColorProvider {

    var animation: (() -> Void) {
        return { [unowned self] in
            self.onboardingDelegate?.backgroundColor = self.backgroundColor
            self.onboardingDelegate?.progress = self.currentProgress
        }
    }

}

protocol OnboardingViewControllerDelegate: class {

    var backgroundColor: UIColor? { get set }
    var progress: Progress { get set }

}

class OnboardingNavigationViewController: BoardingNavigationController, OnboardingViewControllerDelegate {

    // We're creating a non-standard progress slider because the UIProgressView
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

    var backgroundColor: UIColor? {
        get {
            return view.backgroundColor
        }
        set {
            view.backgroundColor = newValue
        }
    }

    static func sampleOnboarding() -> BoardingNavigationController {
        let viewControllers = [
            FirstViewController(),
            SecondViewController(),
            ThirdViewController(),
            ]
        let onboarding = OnboardingNavigationViewController(viewControllersToPresent: viewControllers)
        return onboarding
    }

    func beginOnboarding() {
        let viewControllers = [UIColor.red, UIColor.green, UIColor.blue].map { color -> UIViewController in
            let viewController = UIViewController()
            viewController.view.backgroundColor = color
            return viewController
        }
        let onboarding = BoardingNavigationController(viewControllersToPresent: viewControllers)
        present(onboarding, animated: true, completion: nil)
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

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        (viewController as? BackgroundColorProvider)?.onboardingDelegate = self
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        (viewController as? BackgroundColorProvider)?.onboardingDelegate = self
        return viewController
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = super.popToViewController(viewController, animated: animated)
        (viewController as? BackgroundColorProvider)?.onboardingDelegate = self
        return poppedViewControllers
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        for viewController in viewControllers {
            (viewController as? BackgroundColorProvider)?.onboardingDelegate = self
        }
    }

}
